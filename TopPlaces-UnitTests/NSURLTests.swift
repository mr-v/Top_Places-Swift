//
//  NSURLTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation
import XCTest

class NSURLTests: XCTestCase {

    func test_InitSizesJSONObject__SizesContainOriginalPhoto_CreatesURLWitPreviousBiggestSizeURL() {
        let url = NSURL(sizesJSONObject: makeStubSizesWithOriginalPhotoSize())

        let expected = NSURL(string: "https://farm1.staticflickr.com/2/1418878_1e92283336_z.jpg?zz=1")!
        XCTAssertEqual(expected, url!)
    }

    func test_InitSizesJSONObject_SizesDontContainOrigalPhoto_InvokesCallbackWithBiggestSizeURL() {
        let url = NSURL(sizesJSONObject: makeStubSizes())

        let expected = NSURL(string: "https://farm1.staticflickr.com/2/1418878_1e92283336_z.jpg?zz=1")!
        XCTAssertEqual(expected, url!)
    }
}
