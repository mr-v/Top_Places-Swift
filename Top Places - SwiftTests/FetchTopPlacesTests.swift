//
//  FetchTopPlacesTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FetchTopPlacesTests: XCTestCase {

    func test_Execute_OnSuccess_CallsCompletionHandlerWithOKResult() {
        var result: Result<[FlickrPlace]>?
        let useCase = makeFetchTopPlaces(.OK(NSDictionary())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(_):
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func test_Execute_OnError_CallsCompletionHandlerWithErrorResult() {
        var result: Result<[FlickrPlace]>?
        let useCase = makeFetchTopPlaces(.Error) { r in result = r }

        useCase.execute()

        switch result! {
        case .Error:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }


    // MARK: - factory methods

    private func makeFetchTopPlaces(serviceResponse: Result<NSDictionary>, completionHandler: (Result<[FlickrPlace]>) -> ()) -> FetchTopPlaces {
        let stubService = StubService(response: serviceResponse)
        let useCase = FetchTopPlaces(service: stubService, completionHandler: completionHandler)
        return useCase
    }

    private class StubService: IService {
        let response: Result<NSDictionary>

        init(response: Result<NSDictionary>) {
            self.response = response
        }

        private func fetchJSON(completionHandler: Result<NSDictionary> -> ()) {
            completionHandler(response)
        }
    }
}
