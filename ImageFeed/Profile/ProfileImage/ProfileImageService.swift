//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 19.06.2023.
//

import Foundation

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    // MARK: - Private Properties
    private var activeSessionTask: URLSessionTask?
    private var lastToken: String?

    private(set) var avatarURL: String?

    // MARK: - Public methods
    func fetchProfileImageURL(username: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard let token = OAuth2TokenStorage.shared.authToken else {
            return
        }

        if lastToken == token { return }

        activeSessionTask?.cancel()
        lastToken = token

        let request = makeRequest(with: token, username: username)

        loadObject(for: request) { [weak self] result in
            switch result {
            case .success(let userResult):
                let avatarURL = userResult.profileImage.small
                self?.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": avatarURL])
            case .failure(let error):
                completion(.failure(error))
                if case URLSession.NetworkError.urlSessionError = error {
                    self?.lastToken = nil
                }
            }
        }
    }

    // MARK: - Private methods
    private func loadObject(for request: URLRequest, completion: @escaping (Result<UserResult, Error>) -> Void) {
        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            completion(result)
            self?.activeSessionTask = nil
        }

        activeSessionTask = dataTask
        dataTask.resume()
    }

    private func makeRequest(with token: String, username: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/users/\(username)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
