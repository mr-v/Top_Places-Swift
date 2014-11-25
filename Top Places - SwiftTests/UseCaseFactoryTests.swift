//
//  UseCaseFactory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class UseCaseFactoryTests: XCTestCase {

    func test_Create_UpdateTopPlacesParameter_CreatesUpdateTopPlaces() {
        let factory = makeUseCaseFactory()
        let completionHandler: ResultFlickrPlaceCompletionHandler = { _ in }
        let parameters: [String: Any] = [CompletionHandlerUseCaseKey: completionHandler]

        let useCase = factory.createWithType(.UpdateTopPlaces, parameters: parameters) as? UpdateTopPlaces

        XCTAssertNotNil(useCase)
    }

    // MARK: -

    func makeUseCaseFactory() -> UseCaseFactory {
        let service = WebService(baseURLString: "", defaultParameters: [String: Any]())
        return UseCaseFactory(service: service)
    }
}
