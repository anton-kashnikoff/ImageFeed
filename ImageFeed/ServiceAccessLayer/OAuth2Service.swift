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
        // если коды не совпадают, то делаем новый запрос
        if lastCode == code {
            return
        }
        activeSessionTask?.cancel() // отменяем старый запрос, но если activeSessionTask == nil, то ничего не будет выполнено, и мы просто пройдём дальше вниз
        lastCode = code // запоминаем код, использованный в запросе

        let request = makeRequest(code: code)

        loadObject(for: request) { [weak self] result in
            switch result {
            case .success(let tokenResponseBody):
                let authToken = tokenResponseBody.accessToken
                OAuth2TokenStorage().authToken = authToken
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
