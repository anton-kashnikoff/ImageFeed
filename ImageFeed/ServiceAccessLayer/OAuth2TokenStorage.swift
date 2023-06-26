//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Антон Кашников on 03.06.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
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
}
