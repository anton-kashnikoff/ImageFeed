//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 21.07.2023.
//

import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testImagesListViewControllerCallsViewDidLoad() {
        // given
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenterSpy()
        imagesListViewController.imagesListPresenter = imagesListPresenter
        imagesListPresenter.imagesListViewController = imagesListViewController
        imagesListViewController.tableView = UITableView()
        
        // when
        _ = imagesListViewController.view
        
        // then
        XCTAssertTrue(imagesListPresenter.viewDidLoadCalled)
    }
    
    func testImagesListViewControllerCallsConfigCell() {
        // given
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenterSpy()
        imagesListViewController.imagesListPresenter = imagesListPresenter
        imagesListPresenter.imagesListViewController = imagesListViewController
        imagesListViewController.tableView = UITableView()
        
        let imagesListCell = ImagesListCell()
        let indexPath = IndexPath(row: 0, section: 0)
        
        let imagesListService = ImagesListService()
        imagesListService.photos = [PhotoSpy()]
        imagesListViewController.imagesListService = imagesListService
        
        // when
        imagesListViewController.configCell(for: imagesListCell, with: indexPath)
        
        // then
        XCTAssertTrue(imagesListPresenter.configCellCalled)
    }
    
    func testImagesListPresenterCallsShowErrorAlert() {
        // given
        let imagesListViewController = ImagesListViewControllerSpy()
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.imagesListPresenter = imagesListPresenter
        imagesListPresenter.imagesListViewController = imagesListViewController
        
        let imagesListCell = ImagesListCell()
        let photo = PhotoSpy()
        
        let imagesListService = ImagesListServiceSpy()
        imagesListService.photos = [photo]
        imagesListPresenter.imagesListService = imagesListService
        
        // when
        imagesListPresenter.changeLike(for: imagesListCell, photo: photo)
        
        // then
        XCTAssertTrue(imagesListViewController.showErrorAlertCalled)
    }
}
