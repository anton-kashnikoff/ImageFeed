//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Антон Кашников on 28.06.2023.
//

import Foundation

extension Date {
    func getDate(from string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.date(from: string)
    }
}
