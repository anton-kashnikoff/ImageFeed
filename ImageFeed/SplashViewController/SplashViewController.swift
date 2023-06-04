//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 04.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let _ = oauth2TokenStorage.authToken {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: "ShowAuthenticationScreen", sender: nil)
        }
    }

    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }

        let tabBarViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
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

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            self?.oauth2Service.fetchAuthToken(code) { [weak self] result in
                switch result {
                case .success:
                    self?.switchToTabBarController()
                case .failure:
                    // TODO: Sprint_11
                    break
                }
            }
        }
    }
}
