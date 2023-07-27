//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Антон Кашников on 22.07.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 15))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 15))
        loginTextField.tap()
        loginTextField.typeText("e-mail")
        
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
        
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        webView.swipeUp()
        
        let webViewsQuery = app.webViews
        webViewsQuery.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        sleep(5)
        
        let tablesQuery = app.tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButtonToTap"].tap()
        
        sleep(5)
        
        cellToLike.buttons["likeButtonToTap"].tap()
        
        sleep(2)
        
        cellToLike.tap()
        
        sleep(5)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        
        app.buttons["nav back button white"].tap()
    }
    
    func testProfile() throws {
        sleep(5)
        
        app.tabBars.buttons.element(boundBy: 1).tap()
        
        sleep(3)
        
        XCTAssertTrue(app.staticTexts["Anton Kashnikov"].exists)
        XCTAssertTrue(app.staticTexts["@prostokot14"].exists)
        
        app.buttons["logout"].tap()
        
        sleep(1)
        
        app.alerts["Вы уверены, что хотите выйти?"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
