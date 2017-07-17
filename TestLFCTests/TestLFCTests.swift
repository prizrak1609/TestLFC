//
//  TestLFCTests.swift
//  TestLFCTests
//
//  Created by Dima Gubatenko on 14.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import XCTest
@testable import TestLFC

class TestLFCTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(true)
    }

    func testFlickrApiSearchPhotosGeo() {
        var model = GeoSearchPhoto()
        model.lat = 37.322998
        model.lon = -122.032182
        let flickrApi = FlickrApi()
        let wait = expectation(description: "search photos")
        flickrApi.searchPhotos(geo: model) { result in
            switch result {
                case .error(let text): XCTAssertTrue(false, text)
                case .success(let model):
                    XCTAssertTrue(model.count > 0)
                    wait.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }

    func testFlickrApiSearchPhotosText() {
        let model = TextSearchPhotoModel()
        let flickrApi = FlickrApi()
        let wait = expectation(description: "search photos")
        flickrApi.searchPhotos(text: model) { result in
            switch result {
                case .error(let text): XCTAssertTrue(false, text)
                case .success(let model):
                    XCTAssertTrue(model.count > 0)
                    wait.fulfill()
            }
        }
        waitForExpectations(timeout: 20, handler: nil)
    }
}
