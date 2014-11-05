//
//  FlickrServiceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

typealias DeserializedJSONClosure = (NSDictionary) -> ()

class FlickrServiceTests: XCTestCase {

    func test_FetchTopPlaces_SuccessfulRequest_ContainsArrayOfPlaces() {
        let expectation = expectationWithDescription("top places fetched")
        let service = makeFlickrService {
            jsonObject in
            expectation.fulfill()
            let places = jsonObject.valueForKeyPath("places.place") as? [NSDictionary]
            XCTAssertNotNil(places?)
        }

        service.fetchTopPlaces()

        waitForExpectationsWithTimeout(10) {
            error in
            service.urlSession.invalidateAndCancel()
        }
    }

    func test_FetchPhotosFromPlace_SuccessfulRequest_ContainsArraysOfPhoto() {
        let expectation = expectationWithDescription("photos from place fetched")
        let service = makeFlickrService {
            jsonObject in
            expectation.fulfill()
            let places = jsonObject.valueForKeyPath("photos.photo") as? [NSDictionary]
            XCTAssertNotNil(places?)
        }
        let placeId = "hP_s5s9VVr5Qcg"

        service.fetchPhotosFromPlace(placeId)

        waitForExpectationsWithTimeout(10) {
            error in
            service.urlSession.invalidateAndCancel()
        }
    }

    func test_FetchSizesForPhotoId_SuccessfulRequest_ContainsArrayOfSizes() {
        let expectation = expectationWithDescription("photo sizes fetched")
        let service = makeFlickrService {
            jsonObject in
            expectation.fulfill()
            let sizes = jsonObject.valueForKeyPath("sizes.size") as? [NSDictionary]
            XCTAssertNotNil(sizes?)
        }
        let placeId = "hP_s5s9VVr5Qcg"

        service.fetchSizesForPhotoId("1418878")

        waitForExpectationsWithTimeout(10) {
            error in
            service.urlSession.invalidateAndCancel()
        }
    }

    // TODO: - test error cases

    // MARK: -

    private func makeFlickrService(updateCallback: DeserializedJSONClosure) -> FlickrService {
        return FlickrService(adapter: StubNetworkAdapter(updateCallback: updateCallback))
    }

    class StubNetworkAdapter: FlickrAppNetworkAdapter {
        private let updateCallback: DeserializedJSONClosure

        init(updateCallback: DeserializedJSONClosure) {
            self.updateCallback = updateCallback
            super.init(app: FlickrApp())
        }

        override func updateTopPlacesWithJSONObject(json: NSDictionary){
            updateCallback(json)
        }

        override func updatePhotosFromPlace(placeId: String, json: NSDictionary) {
            updateCallback(json)
        }

        override func updatePickedPhotoURL(json: NSDictionary) {
            updateCallback(json)
        }
    }
}
