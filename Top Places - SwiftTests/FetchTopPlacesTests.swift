//
//  UpdateTopPlacesTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class UpdateTopPlacesTests: XCTestCase {


    func test_Execute_SuccessResponse_CallsCompletionHandlerWithOKResult() {
        var result: Result<[String: [Place]]>?
        let useCase = makeUpdateTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

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
        let useCase = makeUpdateTopPlaces(.Error) { r in result = r }

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
        let useCase = makeUpdateTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

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
        let useCase = makeUpdateTopPlaces(.OK(stubTopPlacesJSONResponse())) { r in result = r }

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

    private func makeUpdateTopPlaces(serviceResponse: Result<NSDictionary>, completionHandler: (Result<[String :[Place]]>) -> ()) -> UpdateTopPlaces {
        let stubService = StubService(response: serviceResponse)
        let useCase = UpdateTopPlaces(service: stubService, completionHandler: completionHandler)
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
