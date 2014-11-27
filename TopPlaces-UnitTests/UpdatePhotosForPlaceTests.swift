//
//  UpdatePhotosForPlaceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class UpdatePhotosForPlaceTests: XCTestCase {

    func test_Execute_SuccessResponse_CallsCompletionHandlerWithOKResult() {
        var result: Result<(String, [Photo])>?
        let useCase = makeUpdatePhotosForPlace(.OK(makeStubPhotoSearchJSONObject())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(_):    XCTAssertTrue(true)
        default:        XCTFail()
        }
    }

    func test_Execute_ErrorResponse_CallsCompletionHandlerWithErrorResult() {
        var result: Result<(String, [Photo])>?
        let useCase = makeUpdatePhotosForPlace(.Error) { r in result = r }

        useCase.execute()

        switch result! {
        case .Error:    XCTAssertTrue(true)
        default:        XCTFail()
        }
    }

    func test_Execute_SuccessResponse_CompletionHandlerResultContainsPhotos() {
        var result: Result<(String, [Photo])>?
        let useCase = makeUpdatePhotosForPlace(.OK(makeStubPhotoSearchJSONObject())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(let (_, photos)):
            let expected = [Photo(title: photoTitle, description: photoDescription, photoId: photoId)]
            XCTAssertEqual(expected, photos)
        default:
            XCTFail()
        }
    }

    func test_Execute_SuccessResponse_CompletionHandlerResultContainsPlaceId() {
        var result: Result<(String, [Photo])>?
        let useCase = makeUpdatePhotosForPlace(.OK(makeStubPhotoSearchJSONObject())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(let (resultPlaceId, _)):   XCTAssertEqual(placeId, resultPlaceId)
        default:                            XCTFail()
        }
    }

    // MARK: -
    private let placeId = "0"

    private func makeUpdatePhotosForPlace(serviceResponse: Result<NSDictionary>, completionHandler: (Result<(String, [Photo])>) -> ()) -> UpdatePhotosForPlace {
        let stubService = StubService(response: serviceResponse)
        let useCase = UpdatePhotosForPlace(placeId: placeId, service: stubService, completionHandler: completionHandler)
        return useCase
    }
}
