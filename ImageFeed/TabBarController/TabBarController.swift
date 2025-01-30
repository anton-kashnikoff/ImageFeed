//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 26.06.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        let imagesListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")

        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        
        profileViewController.profilePresenter = profilePresenter
        profilePresenter.profileViewController = profileViewController
        
        profilePresenter.profileService = ProfileService.shared
        profileViewController.tabBarItem = UITabBarItem(title: nil, image: UIImage.tabProfileActive, selectedImage: nil)

        viewControllers = [imagesListViewController, profileViewController]
    }
}
