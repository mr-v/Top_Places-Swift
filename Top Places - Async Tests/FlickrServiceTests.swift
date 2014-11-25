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

    func test_FetchSizesForPhotoId_SuccessfulRequest_ContainsArrayOfSizes() {
        let expectation = expectationWithDescription("photo sizes fetched")
        let service = makeFlickrService {
            jsonObject in
            expectation.fulfill()
            let sizes = jsonObject.valueForKeyPath("sizes.size") as? [NSDictionary]
            XCTAssertNotNil(sizes?)
        }
        let placeId = "hP_s5s9VVr5Qcg"

        service.fetchSizesForPhotoId("1418878") { url in }

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

        override func updatePickedPhotoURL(json: NSDictionary, callback: URLCallback) {
            updateCallback(json)
        }
    }
}
