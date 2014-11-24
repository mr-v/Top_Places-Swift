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

    func test_FetchJSON_200_CallCompletionHandlerWithJSONObject() {
        let urlString = "https://api.flickr.com/services/rest/"
        let defaultParameters: [String: Any] = ["format": "json",
            "nojsoncallback": 1,
            "api_key": "8bac83dae148d108bd0ac45ca6fd07c3"]

        let service = WebService(baseURLString: urlString, defaultParameters: defaultParameters)
        // @"{\"ok\":true}"
        service.fetchJSON([String: Any]()) { result in
            switch result {
            case .OK(let data):
                XCTAssertEqual(["ok": true], data)
            default:
                XCTFail()
            }
        }
        XCTFail()
    }
}
