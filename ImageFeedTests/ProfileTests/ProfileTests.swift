//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 20.07.2023.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testProfileViewControllerCallsUpdateAvatar() {
        // given
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenterSpy()
        profileViewController.profilePresenter = profilePresenter
        profilePresenter.profileViewController = profileViewController
        
        // when
        _ = profileViewController.view
        
        // then
        XCTAssertTrue(profilePresenter.updateAvatarCalled)
    }
    
    func testProfileViewControllerCallsUpdateProfileDetails() {
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenterSpy()
        profileViewController.profilePresenter = profilePresenter
        profilePresenter.profileViewController = profileViewController
        
        // when
        _ = profileViewController.view
        
        // then
        XCTAssertTrue(profilePresenter.updateProfileDetailsCalled)
    }
}
