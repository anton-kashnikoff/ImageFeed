//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 04.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared

    // MARK: - UIViewController
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.authToken {
            fetchProfile(with: token)
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "ShowAuthenticationScreen", sender: nil)
        }
    }

    // MARK: - Private methods
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }

        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
    }

    private func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()

                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] result in
                    switch result {
                    case .success(let profileImagePath):
                        print(profileImagePath)
                    case .failure(_):
                        self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось загрузить фото профиля")
                    }
                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось войти в систему")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAuthenticationScreen" {
            guard let navigationController = segue.destination as? UINavigationController, let authViewController = navigationController.viewControllers[0] as? AuthViewController else {
                fatalError("Failed to prepare for ShowAuthenticationScreen")
            }

            authViewController.delegate = self
        } else {
            prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            self?.oauth2Service.fetchAuthToken(code) { [weak self] result in
                switch result {
                case .success(let token):
                    self?.fetchProfile(with: token)
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self?.showAlert(title: "Что-то пошло не так.", message: "Не удалось получить токен авторизации")
                    break
                }
            }
        }
    }
}
