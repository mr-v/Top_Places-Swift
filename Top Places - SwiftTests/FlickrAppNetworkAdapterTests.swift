//
//  TopPlacesNetworkAdapterTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrAppNetworkAdapterTests: XCTestCase {

    func test_UpdateWithJSONObject_UpdatesTopPlaces() {
        let (app, adapter) = makeTopPlacesNetworkAdapter()
        let defaultZeroCount = app.topPlaces.count

        adapter.updateWithJSONObject(stubJSONObject())

        XCTAssertNotEqual(defaultZeroCount, app.topPlaces.count)
    }

    func test_UpdateWithJSONObject_ExtractsCountry() {
        let (app, adapter) = makeTopPlacesNetworkAdapter()

        adapter.updateWithJSONObject(stubJSONObject())

        let result = app.topPlaces.keys.first!
        XCTAssertEqual("United Kingdom", result)
    }

    func test_UpdateWithJSONObject_ExtractsPlace() {
        let (app, adapter) = makeTopPlacesNetworkAdapter()

        adapter.updateWithJSONObject(stubJSONObject())

        let result = app.topPlaces["United Kingdom"]![0]
        XCTAssertEqual("London", result.name)
    }

    func test_UpdateWithJSONObject_ExtractsDescription() {
        let (app, adapter) = makeTopPlacesNetworkAdapter()

        adapter.updateWithJSONObject(stubJSONObject())

        let result = app.topPlaces["United Kingdom"]![0]
        XCTAssertEqual("England", result.description)
    }

    // MARK: - factory methods

    func makeTopPlacesNetworkAdapter() -> (FlickrApp, FlickrAppNetworkAdapter) {
        let app = FlickrApp()
        return (app, FlickrAppNetworkAdapter(app: app))
    }

    func stubJSONObject() -> NSDictionary {
        return [ "places": [ "total": 1,
            "place": [
                [ "place_id": "hP_s5s9VVr5Qcg", "woeid": "44418", "latitude": 51.506, "longitude": -0.127, "place_url": "/United+Kingdom/England/London", "place_type": "locality", "place_type_id": 7, "timezone": "Europe/London", "_content": "London, England, United Kingdom", "woe_name": "London", "photo_count": "1734" ]]]] as NSDictionary
        
    }
}
