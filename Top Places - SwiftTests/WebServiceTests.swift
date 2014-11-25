//
//  WebServiceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class WebServiceTests: XCTestCase {

    let baseURL = "https://www.google.com"

    deinit {
        LSNocilla.sharedInstance().stop()
    }

    override func setUp() {
        super.setUp()

        LSNocilla.sharedInstance().start()
        LSNocilla.sharedInstance().clearStubs()
    }

    override func tearDown() {
        LSNocilla.sharedInstance().stop()
    }

    func test_FetchJSON_200ProperJSON_CallCompletionHandlerWithJSONObject() {
        let e = expectationWithDescription("200ProperJSON")
        stubCorrectJSONResponse()
        let urlString = baseURL
        let service = WebService(baseURLString: urlString, defaultParameters: [String: Any]())
        service.fetchJSON([String: Any]()) { result in
            e.fulfill()
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
        let e = expectationWithDescription("200ImproperJSON")
        stubImproperJSONResponse()
        let urlString = baseURL
        let service = WebService(baseURLString: urlString, defaultParameters: [String: Any]())
        service.fetchJSON([String: Any]()) { result in
            e.fulfill()
            switch result {
            case .Error:
                XCTAssertTrue(true)
            default:
                XCTFail()
            }
        }
        waitForExpectationsAndFailAfterTimeout(10)
    }

    // MARK: -

    private func waitForExpectationsAndFailAfterTimeout(timeout: NSTimeInterval) {
        waitForExpectationsWithTimeout(timeout) {
            if let error = $0 {
                XCTFail()
            }
        }
    }

    private func stubCorrectJSONResponse() {
        stubRequest("GET", baseURL).andReturn(200).withBody("{\"ok\":true}")
    }

    private func stubImproperJSONResponse() {
        stubRequest("GET", baseURL).andReturn(200).withBody("{1}")
    }
}
