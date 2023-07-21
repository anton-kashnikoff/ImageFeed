//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 21.07.2023.
//

import ImageFeed

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    enum ErrorSpy: Error {
        case ErrorSpy
    }
    
    var photos = [PhotoProtocol]()
    
    func fetchPhotosNextPage() {
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<LikePhotoResult, Error>) -> Void) {
        completion(.failure(ErrorSpy.ErrorSpy))
    }
}
