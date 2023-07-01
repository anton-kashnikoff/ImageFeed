//
//  ImagesListServiceTests.swift
//  ImageFeedTests
//
//  Created by Антон Кашников on 30.06.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testExample() throws {
        let service = ImagesListService()

        let expectation = expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { _ in
            expectation.fulfill()
        }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
