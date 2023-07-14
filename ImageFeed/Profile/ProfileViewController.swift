//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 16.05.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    // MARK: - Visual Components
    private var profileImageView = UIImageView()
    private var nameLabel = UILabel()
    private var loginNameLabel = UILabel()
    private var descriptionLabel = UILabel()
    private var logoutButton = UIButton()

    // MARK: - Private Properties
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - UIViewController
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .ypBlack
        
        configureLogoutButton()
        configureProfileImageView()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()

        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateAvatar()
            self?.updateProfileDetails()
        }

        updateAvatar()
        updateProfileDetails()
    }

    // MARK: - Private methods
    private func updateAvatar() {
        guard let profileImagePath = ProfileImageService.shared.avatarURL else {
            return
        }

        let processor = RoundCornerImageProcessor(cornerRadius: 16, backgroundColor: UIColor.ypBlack)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: URL(string: profileImagePath), options: [.processor(processor)])
    }

    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.image = UIImage(named: "placeholder")
        view.addSubview(profileImageView)
        
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImageView.trailingAnchor.constraint(lessThanOrEqualTo: logoutButton.leadingAnchor, constant: 0)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight(700))
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLoginNameLabel() {
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureLogoutButton() {
        logoutButton = UIButton.systemButton(with: UIImage(named: "logout_button") ?? UIImage(), target: self, action: #selector(didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .ypRed
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func updateProfileDetails() {
        nameLabel.text = profileService.profile?.name
        loginNameLabel.text = profileService.profile?.loginName
        descriptionLabel.text = profileService.profile?.bio
    }
    
    private func switchToSplashViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let splashViewController = SplashViewController()
        splashViewController.showLoadingCircle = true
        window.rootViewController = splashViewController
    }
    
    @objc private func didTapLogoutButton() {
        let alertController = UIAlertController(title: "Вы уверены, что хотите выйти?", message: "Чтобы продолжить смотреть фотографии, нужно будет заново авторизоваться.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self else {
                return
            }
            
            self.profileService.clean()
            
            self.updateAvatar()
            self.nameLabel = UILabel()
            self.loginNameLabel = UILabel()
            self.descriptionLabel = UILabel()
            self.logoutButton = UIButton()
            
            self.switchToSplashViewController()
        })
        alertController.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alertController, animated: true)
    }
}
