//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 15.06.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?

    private enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String

    init(profileResult: ProfileResult) {
        self.username = profileResult.username
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio ?? ""
    }
}

final class ProfileService {
    static let shared = ProfileService()

    // MARK: - Private Properties
    private var activeSessionTask: URLSessionTask?
    private var lastToken: String?

    private(set) var profile: Profile?

    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)

        if lastToken == token {
            return
        }
        activeSessionTask?.cancel()
        lastToken = token

        let request = makeRequest(with: token)

        let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data, let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode {
                guard let profileResult = try? JSONDecoder().decode(ProfileResult.self, from: data) else {
                    return
                }
                DispatchQueue.main.async {
                    let profile = Profile(profileResult: profileResult)
                    completion(.success(profile))
                    self?.profile = profile
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
    private func makeRequest(with token: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://api.unsplash.com/me")!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
