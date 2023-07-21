//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Антон Кашников on 11.05.2023.
//

import UIKit
import Kingfisher

public protocol ImagesListCellProtocol {
    var cellImage: UIImageView! { get }
    var dateLabel: UILabel! { get }
    var likeButton: UIButton! { get }
}

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell & ImagesListCellProtocol {
    // MARK: - IBOutlet
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    // MARK: - Public Properties
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - UITableViewCell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - IBAction
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Constants
    static let reuseIdentifier = "ImagesListCell"
}
