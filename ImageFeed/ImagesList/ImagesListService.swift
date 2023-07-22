//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 28.06.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<LikePhotoResult, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    // MARK: - Private Properties
    private var lastLoadedPage = 1
    private var activeSessionTask: URLSessionTask?
    private var likeActiveSessionTask: URLSessionTask?
    
    // MARK: - Public Properties
    var photos = [Photo]()
    
    // MARK: - Public methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage.shared.authToken else {
            return
        }

        activeSessionTask?.cancel()
        
        let nextPage = lastLoadedPage == 1 ? 1 : lastLoadedPage + 1
        let request = makeRequest(with: token, url: URL(string: "https://api.unsplash.com/photos?page=\(nextPage)")!, method: "GET")
        
        loadObject(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResult):
                DispatchQueue.main.async {
                    for photo in photoResult {
                        let photo = Photo(photoResult: photo)
                        self?.photos.append(photo)
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self?.lastLoadedPage = nextPage
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<LikePhotoResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage.shared.authToken else {
            return
        }
        
        likeActiveSessionTask?.cancel()
        
        let request = makeRequest(with: token, url: URL(string: "https://api.unsplash.com/photos/\(photoId)/like")!, method: isLike ? "DELETE" : "POST")
        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let photoResult):
                if let index = self.photos.firstIndex(where: {
                    $0.id == photoId
                }) {
                    self.photos[index] = Photo(photoResult: photoResult.photo)
                }
                completion(.success(photoResult))
                self.likeActiveSessionTask = nil
            case .failure(let error):
                completion(.failure(error))
                self.likeActiveSessionTask = nil
            }
        }
        
        likeActiveSessionTask = dataTask
        dataTask.resume()
    }
    
    // MARK: - Private Methods
    private func loadObject(for request: URLRequest, completion: @escaping (Result<[PhotoResult], Error>) -> Void) {
        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] result in
            completion(result)
            self?.activeSessionTask = nil
        }
        
        activeSessionTask = dataTask
        dataTask.resume()
    }
    
    private func makeRequest(with token: String, url: URL, method: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        if method == "POST" {
            request.httpMethod = "POST"
        } else if method == "DELETE" {
            request.httpMethod = "DELETE"
        }
        
        return request
    }
    
    // MARK: - Constants
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
}
