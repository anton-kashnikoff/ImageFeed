//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Антон Кашников on 07.05.2023.
//

import UIKit
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ProgressHUD.animationType = .systemActivityIndicator
        ProgressHUD.colorAnimation = .ypBlack
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(name: "Main", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
