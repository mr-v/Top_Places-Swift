//
//  WebServiceFlickrTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class WebServiceFlickrTests: XCTestCase {

    func test_FetchJSON_TopPlacesEndpointSuccess_JSONContainsPlacesArray() {
        let expectation = expectationWithDescription("")
        let service = makeWebService()
        let localityPlaceTypeId = "7"
        let parameters: [String: Any] = ["method": "flickr.places.getTopPlacesList",
            "place_type_id": localityPlaceTypeId]

        service.fetchJSON(parameters) { result in
            expectation.fulfill()
            switch result {
            case .OK(let data):
                let places = data.valueForKeyPath("places.place") as? [NSDictionary]
                XCTAssertNotNil(places)
            default:
                XCTFail()
            }
        }
        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_UpdatePhotosForPlaceUseCase_OnSucces_ReturnsResultWithPhotos() {
        let expectation = expectationWithDescription("")
        let service = makeWebService()
        let placeId = "hP_s5s9VVr5Qcg"
        let useCase = UpdatePhotosForPlace(placeId: placeId, service: service) {
            result in
            expectation.fulfill()
            switch result {
            case .OK(let data):
                XCTAssertTrue(true)
            default:
                XCTFail()
            }
        }

        useCase.execute()

        waitForExpectationsAndFailAfterTimeout(10)
    }

    // MARK: -

    private func makeWebService() -> WebService {
        let urlString = "https://api.flickr.com/services/rest/"
        let defaultParameters: [String: Any] = ["api_key": "8bac83dae148d108bd0ac45ca6fd07c3",
            "format": "json",
            "nojsoncallback": "1"]
        let service = WebService(baseURLString: urlString, defaultParameters: defaultParameters)
        return service
    }
}
