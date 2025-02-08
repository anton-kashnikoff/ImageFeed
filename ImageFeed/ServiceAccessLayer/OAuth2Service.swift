//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Кашников on 02.06.2023.
//

import Foundation

final class OAuth2Service {
    // MARK: - Public Properties
    static let shared = OAuth2Service()

    // MARK: - Private Properties
    private var activeSessionTask: URLSessionTask?
    private var lastCode: String?

    // MARK: - Public methods
    func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        // if the codes do not match, then make a new request
        if lastCode == code { return }

        // cancel the old request, but if activeSessionTask == nil, then nothing will be executed, and we will just go further down
        activeSessionTask?.cancel()
        
        // storing the code used in the request
        lastCode = code

        let request = makeRequest(code: code)

        loadObject(for: request) { [weak self] result in
            switch result {
            case .success(let tokenResponseBody):
                let authToken = tokenResponseBody.accessToken
                OAuth2TokenStorage.shared.authToken = authToken
                handler(.success(authToken))
            case .failure(let error):
                handler(.failure(error))
                if case URLSession.NetworkError.urlSessionError = error {
                    self?.lastCode = nil
                }
            }
        }
    }

    // MARK: - Private Methods
    private func loadObject(for request: URLRequest, handler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            handler(result)
            self?.activeSessionTask = nil
        }

        activeSessionTask = dataTask
        dataTask.resume()
    }

    private func makeRequest(code: String) -> URLRequest {
        let authConfiguration = AuthConfiguration.standard
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: authConfiguration.accessKey),
            URLQueryItem(name: "client_secret", value: authConfiguration.secretKey),
            URLQueryItem(name: "redirect_uri", value: authConfiguration.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        return request
    }
}
