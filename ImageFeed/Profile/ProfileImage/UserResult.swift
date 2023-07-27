//
//  UserResult.swift
//  ImageFeed
//
//  Created by Антон Кашников on 21.07.2023.
//

struct UserResult: Codable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}
