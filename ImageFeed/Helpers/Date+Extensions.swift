//
//  Date+Extensions.swift
//  ImageFeed
//
//  Created by Антон Кашников on 24.07.2023.
//

import Foundation

extension Date {
    func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = .current
        return formatter
    }
}
