//
//  FlickrPlaceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrPlaceTests: XCTestCase {

    func test_InitJSONObject_ExtractsName () {
        let place = makePlaceFromJSONObject()

        XCTAssertEqual("London", place.name)
    }

    func test_InitJSONObject_ExtractsDescription() {
        let place = makePlaceFromJSONObject()

        XCTAssertEqual("England", place.description)
    }

    func test_InitJSONObject_ExtractsPlaceId() {
        let place = makePlaceFromJSONObject()

        XCTAssertEqual("hP_s5s9VVr5Qcg", place.placeId)
    }

    // MARK: - factory methods

    private func makePlaceFromJSONObject() -> FlickrPlace {
        return FlickrPlace(jsonObject: stubTopPlaceJSONObject())
    }
}
