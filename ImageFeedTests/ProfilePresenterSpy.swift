//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 20.07.2023.
//

import Foundation
import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var profileViewController: ProfileViewControllerProtocol?
    var profileService: ProfileServiceProtocol?
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func updateProfileDetails() {
        updateProfileDetailsCalled = true
    }
    
    func switchToSplashViewController() {
    }
}
