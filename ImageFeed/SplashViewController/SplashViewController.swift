//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 04.06.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    var showLoadingCircle = false
    
    // MARK: - Visual Components
    private let logoImageView = UIImageView()

    // MARK: - Private Properties
    private let oauth2Service = OAuth2Service()
    private let profileService = ProfileService.shared

    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()

        makeViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = OAuth2TokenStorage.shared.authToken {
            fetchProfile(with: token)
            switchToTabBarController()
        } else {
            UIBlockingProgressHUD.dismiss()
            guard let authViewController = UIStoryboard(
                name: "Main",
                bundle: .main
            ).instantiateViewController(
                withIdentifier: "AuthViewController"
            ) as? AuthViewController else {
                assertionFailure("Failed to show Authentication Screen")
                return
            }

            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }

    // MARK: - Private methods
    private func switchToTabBarController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            fatalError("Invalid Configuration")
        }

        window.rootViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        )
        .instantiateViewController(
            withIdentifier: "TabBarViewController"
        )
    }

    private func fetchProfile(with token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self?.switchToTabBarController()

                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { [weak self] result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        let title: String
                        let message: String
                        
                        if #available(iOS 15, *) {
                            title = String(localized: "Something went wrong", comment: "Alert title when there's an error.")
                            message = String(localized: "Could not load profile image", comment: "Alert message on the Splash screen.")
                        } else {
                            title = NSLocalizedString("Something went wrong", comment: "Alert title when there's an error.")
                            message = NSLocalizedString("Could not load profile image", comment: "Alert message on the Splash screen.")
                        }
                        
                        self?.showAlert(title: title, message: message)
                    }
                }
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                
                let title: String
                let message: String
                
                if #available(iOS 15, *) {
                    title = String(localized: "Something went wrong", comment: "Alert title when there's an error.")
                    message = String(localized: "Could not sign in", comment: "Alert message on the Splash screen.")
                } else {
                    title = NSLocalizedString("Something went wrong", comment: "Alert title when there's an error.")
                    message = NSLocalizedString("Could not sign in", comment: "Alert message on the Splash screen.")
                }
                
                self?.showAlert(title: title, message: message)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let title = if #available(iOS 15, *) {
            String(localized: "OK", comment: "Alert button title.")
        } else {
            NSLocalizedString("OK", comment: "Alert button title.")
        }
        
        alertController.addAction(UIAlertAction(title: title, style: .default))
        present(alertController, animated: true)
    }

    private func makeViewController() {
        view.backgroundColor = .ypBlack
        
        if showLoadingCircle {
            UIBlockingProgressHUD.show()
            showLoadingCircle = false
        } else {
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            logoImageView.image = UIImage.logo
            view.addSubview(logoImageView)
            
            NSLayoutConstraint.activate([
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchAuthToken(code) { [weak self] result in
            self?.dismiss(animated: true) { [weak self] in
                switch result {
                case .success(let token):
                    self?.fetchProfile(with: token)
                case .failure(_):
                    UIBlockingProgressHUD.dismiss()
                    
                    let title: String
                    let message: String
                    
                    if #available(iOS 15, *) {
                        title = String(localized: "Something went wrong", comment: "Alert title when there's an error.")
                        message = String(localized: "Could not get authorization token", comment: "Alert message on the Splash screen.")
                    } else {
                        title = NSLocalizedString("Something went wrong", comment: "Alert title when there's an error.")
                        message = NSLocalizedString("Could not get authorization token", comment: "Alert message on the Splash screen.")
                    }
                    
                    self?.showAlert(title: title, message: message)
                    break
                }
            }
        }
    }
}
