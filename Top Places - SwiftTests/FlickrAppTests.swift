//
//  FlickrAppTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import XCTest

class FlickrAppTests: XCTestCase {

    func test_TopPlaces_DidSet_CallsPortsUpdate() {
        let port = MockPort()
        let app = FlickrApp(port: port)

        app.topPlaces = Dictionary<String, [FlickrPlace]>()

        XCTAssertTrue(port.called)
    }

    // MARK: -

    class MockPort: FlickrAppPort {
        private var called = false

        func topPlacesUpdated() {
            called = true
        }
    }
}
