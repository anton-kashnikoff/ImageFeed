//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Антон Кашников on 15.06.2023.
//

import WebKit

public protocol ProfileServiceProtocol {
    var profile: ProfileProtocol? { get }

    func clean()
}

final class ProfileService: ProfileServiceProtocol {
    
    // MARK: - Public Properties
    static let shared = ProfileService()

    // MARK: - Private Properties
    private var activeSessionTask: URLSessionTask?
    private(set) var profile: ProfileProtocol?

    // MARK: - Public methods
    func clean() {
        OAuth2TokenStorage.shared.removeToken()
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {}
            }
        }
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        activeSessionTask?.cancel()

        let request = makeRequest(with: token)

        loadObject(for: request) { [weak self] result in
            switch result {
            case .success(let profileResult):
                let profile = Profile(profileResult: profileResult)
                self?.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private methods
    private func loadObject(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        let dataTask = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            completion(result)
            self?.activeSessionTask = nil
        }

        activeSessionTask = dataTask
        dataTask.resume()
    }

    private func makeRequest(with token: String) -> URLRequest {
        var request = URLRequest(url: URL(string: unsplashProfileURLString)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
