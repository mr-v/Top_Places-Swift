//
//  WebImageServiceTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class WebImageServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()

        LSNocilla.sharedInstance().start()
        LSNocilla.sharedInstance().clearStubs()
    }

    override func tearDown() {
        LSNocilla.sharedInstance().stop()
    }

    func test_FetchImage_BadURL_CompletionHandlerWithErrorResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebImageService()
        let badURLString = " "

        service.fetchImage(badURLString) { result in
            expectation.fulfill()
            switch result {
            case .Error:    XCTAssertTrue(true)
            default:        XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_FetchImage_200ProperImage_CompletionHandlerWithImageResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebImageService()
        stubImageResponse()

        service.fetchImage(baseURLString) { result in
            expectation.fulfill()
            switch result {
            case .OK(let image):    XCTAssertEqual(self.makeTestImage(), UIImagePNGRepresentation(image))
            default:                XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(10)
    }

    func test_FetchJSON_200ImproperImage_CallsCompletionHandlerWithErrorResult() {
        let expectation = expectationWithDescription("")
        let service = makeWebImageService()
        stubInvalidImageResponse()

        service.fetchImage(baseURLString) { result in
            expectation.fulfill()
            switch result {
            case .Error:    XCTAssertTrue(true)
            default:        XCTFail()
            }
        }

        waitForExpectationsAndFailAfterTimeout(10)
    }

    // MARK: -

    private let baseURLString = "https://www.google.com/images/srpr/logo11w.png"

    private func makeWebImageService() -> WebImageService {
        return WebImageService()
    }

    private func stubImageResponse() {
        let png = makeTestImage()
        stubRequest("GET", baseURLString).andReturn(200).withBody(png)
    }

    private func stubInvalidImageResponse() {
        let text: NSString = "not an image"
        stubRequest("GET", baseURLString).andReturn(200).withBody(text.dataUsingEncoding(NSUTF8StringEncoding))
    }

    func makeTestImage() -> NSData {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()

        CGContextSetFillColorWithColor(context, UIColor.orangeColor().CGColor)
        CGContextFillRect(context, rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIImagePNGRepresentation(image)
    }

}
