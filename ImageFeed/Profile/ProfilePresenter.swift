//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Антон Кашников on 20.07.2023.
//

import UIKit
import Kingfisher

protocol ProfilePresenterProtocol {
    var profileViewController: ProfileViewControllerProtocol? { get set }
    var profileService: ProfileServiceProtocol? { get }
    func updateAvatar()
    func updateProfileDetails()
    func switchToSplashViewController()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var profileViewController: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol?
    
    func updateAvatar() {
        guard let profileImagePath = ProfileImageService.shared.avatarURL else {
            return
        }

        let processor = RoundCornerImageProcessor(cornerRadius: 16, backgroundColor: UIColor.ypBlack)
        profileViewController?.profileImageView.kf.indicatorType = .activity
        profileViewController?.profileImageView.kf.setImage(with: URL(string: profileImagePath), options: [.processor(processor)])
    }
    
    func updateProfileDetails() {
        guard let profileService else {
            return
        }
        
        profileViewController?.nameLabel.text = profileService.profile?.name
        profileViewController?.loginNameLabel.text = profileService.profile?.loginName
        profileViewController?.descriptionLabel.text = profileService.profile?.bio
    }
    
    func switchToSplashViewController() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let window = windowScene.windows.first else {
            fatalError("Invalid Configuration")
        }
        
        let splashViewController = SplashViewController()
        splashViewController.showLoadingCircle = true
        window.rootViewController = splashViewController
    }
}
