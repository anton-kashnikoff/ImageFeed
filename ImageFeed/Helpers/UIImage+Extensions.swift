//
//  UIImage+Extensions.swift
//  ImageFeed
//
//  Created by Антон Кашников on 24.07.2023.
//

import UIKit

extension UIImage {
    static var likeButtonOn: UIImage? {
        UIImage(named: "like_button_on") 
    }

    static var likeButtonOff: UIImage? {
        UIImage(named: "like_button_off")
    }

    static var stub: UIImage? {
        UIImage(named: "stub")
    }

    static var placeholder: UIImage? {
        UIImage(named: "placeholder")
    }

    static var logoutButton: UIImage? {
        UIImage(named: "logout_button")
    }

    static var tabProfileActive: UIImage? {
        UIImage(named: "tab_profile_active")
    }

    static var logo: UIImage? {
        UIImage(named: "logo")
    }
}
