//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 16.05.2023.
//

import UIKit
import Kingfisher

protocol ProfileViewControllerProtocol: AnyObject {
    var profilePresenter: ProfilePresenterProtocol? { get set }
    var profileImageView: UIImageView { get set }
    var nameLabel: UILabel { get set }
    var loginNameLabel: UILabel { get set }
    var descriptionLabel: UILabel { get set }
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    // MARK: - Visual Components
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.placeholder
        return imageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: UIFont.Weight(700))
        return nameLabel
    }()
    
    lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        return loginNameLabel
    }()
    
    lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(with: UIImage.logoutButton ?? UIImage(), target: self, action: #selector(didTapLogoutButton))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .ypRed
        logoutButton.accessibilityIdentifier = "logout"
        return logoutButton
    }()

    // MARK: - Private Properties
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Public Properties
    var profilePresenter: ProfilePresenterProtocol?
    
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
            self?.profilePresenter?.updateAvatar()
            self?.profilePresenter?.updateProfileDetails()
        }

        profilePresenter?.updateAvatar()
        profilePresenter?.updateProfileDetails()
    }

    // MARK: - Private Methods
    private func configureProfileImageView() {
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
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLoginNameLabel() {
        view.addSubview(loginNameLabel)
        
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureDescriptionLabel() {
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor)
        ])
    }
    
    private func configureLogoutButton() {
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func didTapLogoutButton() {
        let alertController = UIAlertController(title: "Вы уверены, что хотите выйти?", message: "Чтобы продолжить смотреть фотографии, нужно будет заново авторизоваться.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self, let profilePresenter else {
                return
            }
            
            profilePresenter.profileService?.clean()
            profilePresenter.updateAvatar()
            profilePresenter.updateProfileDetails()
            
            self.nameLabel.text = nil
            self.loginNameLabel.text = nil
            self.descriptionLabel.text = nil
            self.logoutButton.isHidden = true
            
            profilePresenter.switchToSplashViewController()
        })
        alertController.addAction(UIAlertAction(title: "Нет", style: .cancel))
        present(alertController, animated: true)
    }
}
