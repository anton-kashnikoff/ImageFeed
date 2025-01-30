//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Антон Кашников on 14.06.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            return nil
        }

        return window
    }

    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }

    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
