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

    func test_Create_UpdateTopPlaces_CreatesUpdateTopPlaces() {
        let factory = makeUseCaseFactory()
        let completionHandler: CompletionHandlerForPlaceResult = { _ in }
        let parameters: [String: Any] = [CompletionHandlerUseCaseKey: completionHandler]

        let useCase = factory.createWithType(.UpdateTopPlaces, parameters: parameters) as? UpdateTopPlaces

        XCTAssertNotNil(useCase)
    }

    func test_Create_UpdatePhotosForPlace_CreatesUpdatePhotosForPlace() {
        let factory = makeUseCaseFactory()
        let completionHandler: CompletionHandlerForPhotosResult = { _ in }
        let parameters: [String: Any] = [CompletionHandlerUseCaseKey: completionHandler, PlaceIdUseCaseKey: ""]

        let useCase = factory.createWithType(.UpdatePhotosForPlace, parameters: parameters) as? UpdatePhotosForPlace

        XCTAssertNotNil(useCase)
    }

    // MARK: -

    func makeUseCaseFactory() -> UseCaseFactory {
        let service = WebService(baseURLString: "", defaultParameters: [String: Any]())
        return UseCaseFactory(service: service)
    }
}
