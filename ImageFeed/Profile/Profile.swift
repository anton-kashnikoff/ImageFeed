//
//  Profile.swift
//  ImageFeed
//
//  Created by Антон Кашников on 20.07.2023.
//

import Foundation

public protocol ProfileProtocol {
    var name: String { get }
    var loginName: String { get }
    var bio: String { get }
}

struct Profile: ProfileProtocol {
    let username: String
    let name: String
    let loginName: String
    let bio: String

    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName ?? "")"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}
