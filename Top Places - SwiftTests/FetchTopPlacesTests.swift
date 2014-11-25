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


    func test_Execute_SuccessResponse_CallsCompletionHandlerWithOKResult() {
        var result: Result<[String: [Place]]>?
        let useCase = makeFetchTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(_):
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func test_Execute_ErrorResponse_CallsCompletionHandlerWithErrorResult() {
        var result: Result<[String: [Place]]>?
        let useCase = makeFetchTopPlaces(.Error) { r in result = r }

        useCase.execute()

        switch result! {
        case .Error:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func test_Execute_SuccessResponse_CallsCompletionHandlerWithPlacesGroupedByCountry() {
        var result: Result<[String: [Place]]>?
        let useCase = makeFetchTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(let data):
            XCTAssertEqual(["United Kingdom"], data.keys.array)
        default:
            XCTFail()
        }
    }

    func test_Execute_SuccessResponse_CallsCompletionHandlerWithPlaces() {
        var result: Result<[String: [Place]]>?
        let useCase = makeFetchTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

        useCase.execute()

        switch result! {
        case .OK(let data):
            let expected = [Place(name: "London", description: "England", placeId: "hP_s5s9VVr5Qcg")]
            XCTAssertEqual(expected, data["United Kingdom"]!)
        default:
            XCTFail()
        }
    }


    // MARK: - factory methods

    private func makeFetchTopPlaces(serviceResponse: Result<NSDictionary>, completionHandler: (Result<[String :[Place]]>) -> ()) -> FetchTopPlaces {
        let stubService = StubService(response: serviceResponse)
        let useCase = FetchTopPlaces(service: stubService, completionHandler: completionHandler)
        return useCase
    }

    private class StubService: IService {
        let response: Result<NSDictionary>

        init(response: Result<NSDictionary>) {
            self.response = response
        }

        private func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ()) {
            completionHandler(response)
        }
    }
}
