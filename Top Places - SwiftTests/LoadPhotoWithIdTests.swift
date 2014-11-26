//
//  LoadPhotoWithIdTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class LoadPhotoWithIdTests: XCTestCase {

    func test_Execute_SuccessResponse_CallsCompletionHandlerWithOKResult() {
        var result: Result<UIImage>?
        let useCase = makeLoadPhotoWithId(.OK(makeStubSizesForPhotoJSONResponse()), imageResponse: .OK(UIImage())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(_):    XCTAssertTrue(true)
        default:        XCTFail()
        }
    }

    func test_Execute_ErrorJSONServiceResponse_CallsCompletionHandlerWithErrorResult() {
        var result: Result<UIImage>?
        let useCase = makeLoadPhotoWithId(.Error, imageResponse: .OK(UIImage())) { r in result = r }

        useCase.execute()

        switch result! {
        case .Error:    XCTAssertTrue(true)
        default:        XCTFail()
        }
    }

    func test_Execute_ErrorImageServiceResponse_CallsCompletionHandlerWithErrorResult() {
        var result: Result<UIImage>?
        let useCase = makeLoadPhotoWithId(.OK(makeStubSizesForPhotoJSONResponse()), imageResponse: .Error) { r in result = r }

        useCase.execute()

        switch result! {
        case .Error:    XCTAssertTrue(true)
        default:        XCTFail()
        }
    }

    private func makeLoadPhotoWithId(jsonResponse: Result<NSDictionary>, imageResponse: Result<UIImage>, completionHandler: (Result<UIImage>) -> ()) -> LoadPhotoWithId {
        let stubJSONService = StubService(response: jsonResponse)
        let stubImageService = StubImageService(response: imageResponse)
        return LoadPhotoWithId(photoId: " ", service: stubJSONService, imageService: stubImageService, completionHandler: completionHandler)
    }
}
