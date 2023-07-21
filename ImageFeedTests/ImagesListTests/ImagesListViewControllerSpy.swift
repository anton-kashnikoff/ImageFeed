//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 21.07.2023.
//

import UIKit
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var imagesListService: ImagesListServiceProtocol?
    var imagesListPresenter: ImagesListPresenterProtocol?
    var showErrorAlertCalled = false
    
    func showErrorAlert() {
        showErrorAlertCalled = true
    }
}
