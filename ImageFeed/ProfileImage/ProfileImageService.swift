//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 19.06.2023.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage

    private enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small: String
}

final class ProfileImageService {
    // MARK: - Public Properties
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")

    // MARK: - Private Properties
    private var activeSessionTask: URLSessionTask?
    private var lastToken: String?

    private(set) var avatarURL: String?

    // MARK: - Public methods
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard let token = OAuth2TokenStorage().authToken else {
            return
        }

        if lastToken == token {
            return
        }
        activeSessionTask?.cancel()
        lastToken = token

        let request = makeRequest(with: token, username: username)

        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode {
                guard let userResult = try? JSONDecoder().decode(UserResult.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    let avatarURL = userResult.profileImage.small
                    completion(.success(avatarURL))

                    NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": avatarURL])

                    self?.avatarURL = avatarURL
                    self?.activeSessionTask = nil
                }
            } else if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))

                    self?.activeSessionTask = nil
                }
            }
        }

        activeSessionTask = dataTask
        dataTask.resume()
    }

    // MARK: - Private methods
    private func makeRequest(with token: String, username: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/users/:\(username)")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
