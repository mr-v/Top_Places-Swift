//
//  PhotoTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class PhotoTests: XCTestCase {

    func test_InitJSONObject_HasTitle_ExtractsTitle() {
        let photo = Photo(jsonObject: makePhotoJSONFrom(makeStubPhotoSearchJSONObject()))

        XCTAssertEqual(photoTitle, photo.title)
    }

    func test_InitJSONObject_NoTitle_UsesDescriptionAsTitle() {
        let photo = Photo(jsonObject: makePhotoJSONFrom(makeStubPhotoSearchJSONObjectWithNoTitle()))

        XCTAssertEqual(photoDescription, photo.title)
    }

    func test_InitJSONObject_NoTitleNoDescription_UsesUnknownAsTitle() {
        let photo = Photo(jsonObject: makePhotoJSONFrom(makeStubPhotoSearchJSONObjectWithNoTitleAndNoDescription()))

        XCTAssertEqual("Unknown", photo.title)
    }

    func test_InitJSONObject_ExtractsPhotoId() {
        let photo = Photo(jsonObject: makePhotoJSONFrom(makeStubPhotoSearchJSONObjectWithNoTitleAndNoDescription()))

        XCTAssertEqual("15487869898", photo.photoId)
    }
}
