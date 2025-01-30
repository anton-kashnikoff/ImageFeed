//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Антон Кашников on 27.05.2023.
//

import Foundation

let accessKeyConstant = "LTfzHd9v1j8p7Tq7xSD9QuI6eb-HVaezC3Or_OCOJLc"
let secretKeyConstant = "crW2j2ot4HrvhyX-9VKhmKqoWxpQeYRZi6666_DxCDM"
let redirectURIConstant = "urn:ietf:wg:oauth:2.0:oob"
let accessScopeConstant = "public+read_user+write_likes"
let defaultBaseURLConstant = URL(string: "https://api.unsplash.com/")!
let unsplashAuthorizeURLStringConstant = "https://unsplash.com/oauth/authorize"
let unsplashAuthorizeURLStringPath = "/oauth/authorize/native"
let unsplashProfileURLString = "https://api.unsplash.com/me"

struct AuthConfiguration {
    static var standard = AuthConfiguration(
        accessKey: accessKeyConstant,
        secretKey: secretKeyConstant,
        redirectURI: redirectURIConstant,
        accessScope: accessScopeConstant,
        defaultBaseURL: defaultBaseURLConstant,
        authURLString: unsplashAuthorizeURLStringConstant
    )
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
}
