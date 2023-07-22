//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Антон Кашников on 20.07.2023.
//

import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol {
    var imagesListViewController: ImagesListViewControllerProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get }
    var imagesListHelper: ImagesListHelperProtocol? { get }
    func viewDidLoad()
    func changeLike(for cell: ImagesListCell, photo: Photo)
    func heightForRow(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat
    func configCell(_ cell: ImagesListCell, photo: Photo)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var imagesListViewController: ImagesListViewControllerProtocol?
    var imagesListService: ImagesListServiceProtocol?
    var imagesListHelper: ImagesListHelperProtocol?
    
    func viewDidLoad() {
        imagesListService?.fetchPhotosNextPage()
    }
    
    func changeLike(for cell: ImagesListCell, photo: Photo) {
        UIBlockingProgressHUD.show()
        imagesListService?.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success(_):
                let likeImage = photo.isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
                cell.likeButton?.setImage(likeImage, for: .normal)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                self?.imagesListViewController?.showErrorAlert()
            }
        }
    }
    
    func heightForRow(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        guard let imagesListHelper else {
            return 0
        }
        
        return imagesListHelper.calculateHeightOfCell(with: photo, tableViewWidth: tableViewWidth)
    }
    
    func configCell(_ cell: ImagesListCell, photo: Photo) {
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.kf.setImage(with: URL(string: photo.thumbImageURL), placeholder: UIImage(named: "stub"))
        
        guard let imagesListHelper else {
            return
        }
        
        if let date = photo.createdAt {
            cell.dateLabel.text = imagesListHelper.formatTheDate(date)
        }
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}
