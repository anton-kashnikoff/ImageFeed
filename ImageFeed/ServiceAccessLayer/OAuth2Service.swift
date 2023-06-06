//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Антон Кашников on 02.06.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()

    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }

    func fetchAuthToken(_ code: String, handler: @escaping (Result<String, Error>) -> Void) {
        let request = makeRequest(code: code)

        loadObject(for: request) { result in
            switch result {
            case .success(let tokenResponseBody):
                let authToken = tokenResponseBody.accessToken
                OAuth2TokenStorage().authToken = authToken
                handler(.success(authToken))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func loadObject(for request: URLRequest, handler: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        fetch(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let object = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(object))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

    private func fetch(for request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    DispatchQueue.main.async {
                        handler(.success(data))
                    }
                } else {
                    DispatchQueue.main.async {
                        handler(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                }
            } else if let error {
                DispatchQueue.main.async {
                    handler(.failure(NetworkError.urlRequestError(error)))
                }
            } else {
                DispatchQueue.main.async {
                    handler(.failure(NetworkError.urlSessionError))
                }
            }
        }.resume()
    }

    private func makeRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token")!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "client_secret", value: secretKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "POST"
        
        return request
    }
}
