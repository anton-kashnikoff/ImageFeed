//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Антон Кашников on 03.06.2023.
//

import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    // MARK: - Public Properties
    var authToken: String? {
        get {
            KeychainWrapper.standard.string(forKey: "Auth token")
        }

        set {
            guard KeychainWrapper.standard.set(newValue ?? "", forKey: "Auth token") else {
                return
            }
        }
    }
    
    // MARK: - Public Methods
    func removeToken() {
        guard KeychainWrapper.standard.removeObject(forKey: "Auth token") else {
            return
        }
    }
    
    // MARK: - Constants
    static let shared = OAuth2TokenStorage()
    
    private init() {}
}
