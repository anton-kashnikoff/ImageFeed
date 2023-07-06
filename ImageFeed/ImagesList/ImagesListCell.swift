//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Антон Кашников on 11.05.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    // MARK: - UITableViewCell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    // MARK: - Constants
    static let reuseIdentifier = "ImagesListCell"
}
