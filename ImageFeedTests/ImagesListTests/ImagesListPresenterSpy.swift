//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 21.07.2023.
//

import CoreFoundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var imagesListViewController: ImagesListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol?
    var imagesListHelper: ImagesListHelperProtocol?
    var viewDidLoadCalled = false
    var configCellCalled = false
    var changeLikeCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func changeLike(for cell: ImagesListCell, photo: Photo) {
        changeLikeCalled = true
    }
    
    func heightForRow(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        0
    }
    
    func configCell(_ cell: ImagesListCell, photo: Photo) {
        configCellCalled = true
    }
}
