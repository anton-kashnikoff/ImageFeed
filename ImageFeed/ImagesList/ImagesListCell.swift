//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Антон Кашников on 11.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    // MARK: - IBOutlet
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    
    // MARK: - Public Properties
    weak var delegate: ImagesListCellDelegate?
    let gradient = CAGradientLayer()
    
    // MARK: - UITableViewCell
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
        gradient.removeFromSuperlayer()
    }
    
    // MARK: - Public methods
    func setupGradient(for photo: Photo) {
        gradient.frame = CGRect(origin: .zero, size: photo.size)
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor, UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor, UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        cellImage.layer.addSublayer(gradient)
        
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    // MARK: - IBAction
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    // MARK: - Constants
    static let reuseIdentifier = "ImagesListCell"
}
