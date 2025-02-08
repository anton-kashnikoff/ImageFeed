//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Антон Кашников on 21.07.2023.
//

import UIKit

protocol ImagesListHelperProtocol {
    func calculateHeightOfCell(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat
    func formatTheDate(_ date: Date) -> String
}

final class ImagesListHelper: ImagesListHelperProtocol {
    func calculateHeightOfCell(with photo: Photo, tableViewWidth: CGFloat) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    func formatTheDate(_ date: Date) -> String {
        if #available(iOS 15, *) {
            return date.formatted(date: .long, time: .omitted)
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            formatter.locale = .current
            return formatter.string(from: date)
        }
    }
}
