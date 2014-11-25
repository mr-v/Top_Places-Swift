//
//  Utilities.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
 func waitForExpectationsAndFailAfterTimeout(timeout: NSTimeInterval) {
    waitForExpectationsWithTimeout(timeout) {
        if let error = $0 {
            XCTFail()
        }
    }
}
}