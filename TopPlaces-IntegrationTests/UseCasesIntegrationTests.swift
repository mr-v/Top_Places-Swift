//
//  WebJSONServiceFlickrTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class UseCasesIntegrationTests: XCTestCase {

    func test_UpdateTopPlaces_OnSuccess_ReturnsResultWithPlaces() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        let useCase = UpdateTopPlaces(service: service) {result in
            expectation.fulfill()
            switch result {
            case .OK(let (placesByCountry)):    XCTAssertTrue(true)
            default:                            XCTFail()
            }
        }

        useCase.execute()

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_UpdatePhotosForPlaceUseCase_OnSucces_ReturnsResultWithPhotos() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        let placeId = "hP_s5s9VVr5Qcg"
        let useCase = UpdatePhotosForPlace(placeId: placeId, service: service) {
            result in
            expectation.fulfill()
            switch result {
            case .OK(let (_, photos)):  XCTAssertTrue(true)
            default:                    XCTFail()
            }
        }

        useCase.execute()

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_LoadPhotoWithId_OnSuccess_ReturnsResultWithImage() {
        let expectaction = expectationWithDescription("")
        let photoId = "15487869898"
        let useCase = LoadPhotoWithId(photoId: photoId, service: makeWebJSONService(), imageService: WebImageService()) {
            result in
            expectaction.fulfill()
            switch result {
            case .OK(let image):    XCTAssertTrue(true)
            case .Error:            XCTFail()
            }
        }

        useCase.execute()

        waitForExpectationsAndFailAfterTimeout(10)
    }

    // MARK: -

    private func makeWebJSONService() -> WebJSONService {
        let urlString = "https://api.flickr.com/services/rest/"
        let defaultParameters: [String: Any] = ["api_key": "8bac83dae148d108bd0ac45ca6fd07c3",
            "format": "json",
            "nojsoncallback": "1"]
        let service = WebJSONService(baseURLString: urlString, defaultParameters: defaultParameters)
        return service
    }
}
