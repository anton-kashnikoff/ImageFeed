//
//  UIColor+Extensions.swift
//  ImageFeed
//
//  Created by Антон Кашников on 09.05.2023.
//

import UIKit

extension UIColor {
    static var ypBackground: UIColor {
        UIColor(named: "YP Background") ?? .darkGray
    }

    static var ypBlack: UIColor {
        UIColor(named: "YP Black") ?? .black
    }

    static var ypBlue: UIColor {
        UIColor(named: "YP Blue") ?? .blue
    }

    static var ypGray: UIColor {
        UIColor(named: "YP Gray") ?? .gray
    }

    static var ypRed: UIColor {
        UIColor(named: "YP Red") ?? .red
    }

    static var ypWhiteAlpha50: UIColor {
        UIColor(named: "YP White (Alpha 50)") ?? UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }

    static var ypWhite: UIColor {
        UIColor(named: "YP White") ?? .white
    }
}
