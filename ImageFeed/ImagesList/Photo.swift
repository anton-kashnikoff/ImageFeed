//
//  Photo.swift
//  ImageFeed
//
//  Created by Антон Кашников on 21.07.2023.
//

import Foundation

public protocol PhotoProtocol {
    var id: String { get }
    var size: CGSize { get }
    var createdAt: Date? { get }
    var welcomeDescription: String? { get }
    var thumbImageURL: String { get }
    var largeImageURL: String { get }
    var isLiked: Bool { get }
}

struct Photo: PhotoProtocol {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    init(photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt)
        welcomeDescription = photoResult.description
        thumbImageURL = photoResult.urls.thumb
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.likedByUser
    }
}
