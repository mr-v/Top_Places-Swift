//
//  WebJSONServiceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class WebJSONServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()

        LSNocilla.sharedInstance().start()
        LSNocilla.sharedInstance().clearStubs()
    }

    override func tearDown() {
        LSNocilla.sharedInstance().stop()
    }

    func test_FetchJSON_200ProperJSON_CallsCompletionHandlerWithJSONObject() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        stubCorrectJSONResponse()

        service.fetchJSON([String: Any]()) { result in
            expectation.fulfill()
            switch result {
            case .OK(let data):
                let expected = ["ok": 1] as NSDictionary
                XCTAssertEqual(expected, data)
            default:
                XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_FetchJSON_200ImproperJSON_CallsCompletionHandlerWithErrorResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        stubInvalidJSONResponse()

        service.fetchJSON([String: Any]()) { result in
            expectation.fulfill()
            switch result {
            case .Error:    XCTAssertTrue(true)
            default:        XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_FetchJSON_OtherThat200_CallsCompletionHandlerWithErrorResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        stub404()

        service.fetchJSON([String: Any]()) { result in
            expectation.fulfill()
            switch result {
            case .Error:    XCTAssertTrue(true)
            default:        XCTFail()
            }
        }
        waitForExpectationsAndFailAfterTimeout(10)
    }

    // MARK: - Query formatting tests
    // note: creating query is encapsulated in the service,
    // as a workaround queries are tested with stub requests;
    // if query doesn't match expected stub it will fail after timeout

    func test_FetchJSON_QueryContainsDefaultParameters() {
        let expectation = expectationWithDescription("")
        let parameters = stubRequestWithDefaultParameters()
        let service = makeWebJSONService(defaultParameters: parameters)

        service.fetchJSON([String: Any]()) { result in
            expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsAndFailAfterTimeout(3)
    }

    func test_FetchJSON_QueryContainsParameters() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        let parameters = stubRequestWithParameters()

        service.fetchJSON(parameters) { result in
            expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsAndFailAfterTimeout(3)
    }

    func test_FetchJSON_QueryIsPercentEncoded() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        let parameters = stubRequestWithPercentEncodedParameters()

        service.fetchJSON(parameters) { result in
            expectation.fulfill()
            XCTAssertTrue(true)
        }

        waitForExpectationsAndFailAfterTimeout(3)
    }

    func test_FetchJSON_APIFail_CallsCompletionHandlerWithErrorResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebJSONService()
        stubFailedAPICall()

        service.fetchJSON([String: Any]()) { result in
            expectation.fulfill()
            switch result {
            case .Error:    XCTAssertTrue(true)
            default:        XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(3)
    }

    // MARK: -

    private let baseURLString = "https://www.google.com/"

    private func makeWebJSONService(defaultParameters: [String: Any] = [String: Any]()) -> WebJSONService {
        let service = WebJSONService(baseURLString: baseURLString, defaultParameters: defaultParameters)
        return service
    }

    private func stubCorrectJSONResponse() {
        stubRequest("GET", baseURLString).andReturn(200).withBody("{\"ok\":true}")
    }

    private func stubInvalidJSONResponse() {
        stubRequest("GET", baseURLString).andReturn(200).withBody("{1}")
    }

    private func stub404() {
        stubRequest("GET", baseURLString).andReturn(404).withBody("{\"ok\":false}")
    }

    private func stubRequestWithDefaultParameters() -> [String: Any] {
        let parameters: [String: Any] = ["test": 2, "test2": 3]
        let query = "test2=3&test=2"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }

    private func stubRequestWithParameters() -> [String: Any] {
        let parameters: [String: Any] = ["custom": 2, "custom2": 3]
        let query = "custom2=3&custom=2"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }

    private func stubRequestWithPercentEncodedParameters() -> [String: Any] {
        let parameters: [String: Any] = ["custom": "  ą"]
        let query = "custom=%20%20%C4%85"
        stubRequest("GET", baseURLString + "?" + query).andReturn(200)
        return parameters
    }

    private func stubFailedAPICall() {
        stubRequest("GET", baseURLString).andReturn(200).withBody("{\"stat\":\"fail\"}")
    }
}
