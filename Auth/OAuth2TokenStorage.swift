//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Антон Кашников on 03.06.2023.
//

import Foundation

final class OAuth2TokenStorage {
    private (set) var authToken: String {
        get {
            UserDefaults.standard.string(forKey: "authToken") ?? "There's no access token"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "authToken")
        }
    }
}
