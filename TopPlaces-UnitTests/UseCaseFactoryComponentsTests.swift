//
//  UseCaseFactoryParametersComponentsTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class UseCaseFactoryParametersComponentsTests: XCTestCase {

    func test_PhotoId_ParametersContainPhotoId() {
        let components = UseCaseFactoryParametersComponents()
        let photoId = "test_xjw"

        components.photoId(photoId)

        let result = components.parameters as [String: String]
        XCTAssertEqual([PhotoIdUseCaseKey: photoId], result)
    }

    func test_CompletionHandler_ParametersContainCompletionHandler() {
        let components = UseCaseFactoryParametersComponents()
        let completionHandler = { (result: Result<UIImage>) -> () in  }

        components.completionHandler(completionHandler)

        let result = components.parameters[CompletionHandlerUseCaseKey]
        XCTAssertTrue(result? != nil)
    }

    func test_PlaceId_ParametersContainPlaceId() {
        let components = UseCaseFactoryParametersComponents()
        let placeId = "place_xjxzw"
        components.placeId(placeId)

        let result = components.parameters as [String: String]
        XCTAssertEqual([PlaceIdUseCaseKey: placeId], result)
    }
}
