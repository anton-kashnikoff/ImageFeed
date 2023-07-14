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
    private var animationLayers = Set<CALayer>()
    
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
            self?.animationLayers.forEach {
                $0.removeFromSuperlayer()
            }
            self?.updateAvatar()
            self?.updateProfileDetails()
        }

//        setupPhotoGradient()
//        setupLabelsGradient()
        setupGradient(for: profileImageView, key: "ProfileImageView")
        setupGradient(for: nameLabel, key: "NameLabel")
        setupGradient(for: loginNameLabel, key: "LoginNameLabel")
        setupGradient(for: descriptionLabel, key: "DescriptionLabel")
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
        profileImageView.kf.setImage(with: URL(string: profileImagePath), options: [.processor(processor)]) { [weak self] result in
            switch result {
            case .success(_):
                self?.animationLayers.forEach {
                    $0.removeFromSuperlayer()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self?.profileImageView.image = UIImage(named: "placeholder.jpeg")
            }
        }
    }

    private func configureProfileImageView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        splashViewController.logout = "logout"
        window.rootViewController = splashViewController
    }
    
//    private func setupPhotoGradient() {
//        let gradient = CAGradientLayer()
//        gradient.frame = CGRect(origin: .zero, size: CGSize(width: 70, height: 70))
//        gradient.locations = [0, 0.1, 0.3]
//        gradient.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.cornerRadius = 35
//        gradient.masksToBounds = true
//        animationLayers.insert(gradient)
//        profileImageView.layer.addSublayer(gradient)
//
//        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
//        gradientChangeAnimation.duration = 1.0
//        gradientChangeAnimation.repeatCount = .infinity
//        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
//        gradientChangeAnimation.toValue = [0, 0.8, 1]
//        gradient.add(gradientChangeAnimation, forKey: "locationsPhotoChange")
//    }
    
    private func setupGradient(for view: UIView, key: String) {
        let gradient = CAGradientLayer()
        view.layoutIfNeeded()
        gradient.frame = CGRect(origin: .zero, size: view.frame.size)
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        if view is UIImageView {
            gradient.cornerRadius = 35
            gradient.masksToBounds = true
        }
        animationLayers.insert(gradient)
        view.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        print(view.description)
        gradient.add(gradientChangeAnimation, forKey: "locations\(key)Change")
        print("view.frame.size = \(view.frame.size)")
        print("gradient.frame = \(gradient.frame.size)")
    }
    
//    private func setupLabelsGradient() {
//        let gradientNameLabelChangeAnimation = CABasicAnimation(keyPath: "locations")
//        gradientNameLabelChangeAnimation.duration = 1.0
//        gradientNameLabelChangeAnimation.repeatCount = .infinity
//        gradientNameLabelChangeAnimation.fromValue = [0, 0.1, 0.3]
//        gradientNameLabelChangeAnimation.toValue = [0, 0.8, 1]
//
//        let gradientNameLabel = CAGradientLayer()
//        nameLabel.layoutIfNeeded()
//        gradientNameLabel.frame = CGRect(origin: .zero, size: nameLabel.frame.size)
//        gradientNameLabel.locations = [0, 0.1, 0.3]
//        gradientNameLabel.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
//        gradientNameLabel.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientNameLabel.endPoint = CGPoint(x: 1, y: 0.5)
//        animationLayers.insert(gradientNameLabel)
//        nameLabel.layer.addSublayer(gradientNameLabel)
//        gradientNameLabel.add(gradientNameLabelChangeAnimation, forKey: "locationsNameLabelChange")
//
//        let gradientLoginNameLabelChangeAnimation = CABasicAnimation(keyPath: "locations")
//        gradientLoginNameLabelChangeAnimation.duration = 1.0
//        gradientLoginNameLabelChangeAnimation.repeatCount = .infinity
//        gradientLoginNameLabelChangeAnimation.fromValue = [0, 0.1, 0.3]
//        gradientLoginNameLabelChangeAnimation.toValue = [0, 0.8, 1]
//
//        let gradientLoginNameLabel = CAGradientLayer()
//        loginNameLabel.layoutIfNeeded()
//        gradientLoginNameLabel.frame = CGRect(origin: .zero, size: loginNameLabel.frame.size)
//        gradientLoginNameLabel.locations = [0, 0.1, 0.3]
//        gradientLoginNameLabel.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
//        gradientLoginNameLabel.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLoginNameLabel.endPoint = CGPoint(x: 1, y: 0.5)
//        animationLayers.insert(gradientLoginNameLabel)
//        loginNameLabel.layer.addSublayer(gradientLoginNameLabel)
//        gradientLoginNameLabel.add(gradientLoginNameLabelChangeAnimation, forKey: "locationsLoginNameLabelChange")
//
//        let gradientDescriptionLabelChangeAnimation = CABasicAnimation(keyPath: "locations")
//        gradientDescriptionLabelChangeAnimation.duration = 1.0
//        gradientDescriptionLabelChangeAnimation.repeatCount = .infinity
//        gradientDescriptionLabelChangeAnimation.fromValue = [0, 0.1, 0.3]
//        gradientDescriptionLabelChangeAnimation.toValue = [0, 0.8, 1]
//
//        let gradientDescriptionLabel = CAGradientLayer()
//        descriptionLabel.layoutIfNeeded()
//        gradientDescriptionLabel.frame = CGRect(origin: .zero, size: descriptionLabel.frame.size)
//        gradientDescriptionLabel.locations = [0, 0.1, 0.3]
//        gradientDescriptionLabel.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
//        gradientDescriptionLabel.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientDescriptionLabel.endPoint = CGPoint(x: 1, y: 0.5)
//        animationLayers.insert(gradientDescriptionLabel)
//        descriptionLabel.layer.addSublayer(gradientDescriptionLabel)
//        gradientDescriptionLabel.add(gradientDescriptionLabelChangeAnimation, forKey: "locationsDescriptionLabelChange")
//    }
    
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
