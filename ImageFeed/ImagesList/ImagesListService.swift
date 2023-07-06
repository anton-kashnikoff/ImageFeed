//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 28.06.2023.
//

import Foundation

struct Photo {
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
        createdAt = Date().getDate(from: photoResult.createdAt)
        welcomeDescription = photoResult.description
        thumbImageURL = photoResult.urls.thumb
        largeImageURL = photoResult.urls.full
        isLiked = photoResult.likedByUser
    }
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: String
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: URLsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case description
        case likedByUser = "liked_by_user"
        case urls
    }
}

struct URLsResult: Decodable {
    let thumb: String
    let full: String
}

final class ImagesListService {
    // MARK: - Private Properties
    private(set) var photos = [Photo]()
    private var lastLoadedPage: Int?
    private var activeSessionTask: URLSessionTask?
    
    // MARK: - Public methods
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard let token = OAuth2TokenStorage().authToken else {
            return
        }

        activeSessionTask?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        print("nextPage = \(nextPage)")
        let request = makeRequest(with: token, nextPage: nextPage)
        
        loadObject(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let photoResult):
                DispatchQueue.main.async {
                    for photo in photoResult {
                        let photo = Photo(photoResult: photo)
                        self?.photos.append(photo)
                        print("Photos count in ImageListService: \(self?.photos.count ?? 0)")
                    }
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                    self?.lastLoadedPage = nextPage
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
    private func makeRequest(with token: String, nextPage: Int) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/photos?page=\(nextPage)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - Constants
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
}
