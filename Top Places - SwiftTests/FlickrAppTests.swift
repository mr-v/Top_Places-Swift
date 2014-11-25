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
        let app = FlickrApp()
        let port = MockPort()
        app.topPlacesPorts.append(port)

        app.topPlaces = Dictionary<String, [Place]>()

        XCTAssertTrue(port.called)
    }

    // MARK: -

    class MockPort: FlickrAppTopPlacesPort {
        private var called = false

        func didUpdateTopPlaces() {
            called = true
        }
    }
}
