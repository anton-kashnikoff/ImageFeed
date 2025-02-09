//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Антон Кашников on 20.07.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration

    var authURL: URL {
        var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope)
        ]
        
        return urlComponents.url!
    }
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        URLRequest(url: authURL)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == unsplashAuthorizeURLStringPath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {
                $0.name == "code"
            })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
