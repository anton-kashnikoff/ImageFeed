//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 21.07.2023.
//

import CoreFoundation
import ImageFeed

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
    
    func changeLike(for cell: ImagesListCellProtocol, photo: PhotoProtocol) {
        changeLikeCalled = true
    }
    
    func heightForRow(with photo: PhotoProtocol, tableViewWidth: CGFloat) -> CGFloat {
        0
    }
    
    func configCell(_ cell: ImagesListCellProtocol, photo: PhotoProtocol) {
        configCellCalled = true
    }
}
