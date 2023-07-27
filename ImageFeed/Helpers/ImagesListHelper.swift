//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Антон Кашников on 21.07.2023.
//

import UIKit

protocol ImagesListHelperProtocol {
    var dateFormatter: DateFormatter { get }
    func calculateHeightOfCell(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat
    func formatTheDate(_ date: Date) -> String
}

final class ImagesListHelper: ImagesListHelperProtocol {
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    func calculateHeightOfCell(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func formatTheDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }
}
