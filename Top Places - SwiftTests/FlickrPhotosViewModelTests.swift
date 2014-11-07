//
//  FlickrPhotosViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrPhotosViewModelTests: XCTestCase {

    // MARK: - data source

    func test_NumberOfRowsInSection() {
        let (app, viewModel) = makeViewModel()

        app.setPhotosForPlace("0", photos: makeTestPhotos())

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 2)
        XCTAssertEqual(rowCount, result)
    }

    func test_DidSelectPhotoAtIndexPath_UpdatesCurrentPhotoPort() {
        let (app, viewModel) = makeViewModel()
        let port = StubCurrentPhotoPort()
        app.currentPhotoPort = port

        app.setPhotosForPlace("0", photos: makeTestPhotos())
        viewModel.didSelectPhotoAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertEqual(FlickrPhoto(title: "title 0", description: "description 0", photoId: "0"), port.photo)
    }


//  MARK: -

    let rowCount = 5

    private func makeViewModel() -> (FlickrApp, FlickrPhotosViewModel) {
        let app = FlickrApp()
        let viewModel = FlickrPhotosViewModel(app: app)
        viewModel.placeId = "0"
        return (app, viewModel)
    }

    private func makeTestPhotos() -> [FlickrPhoto] {
        var list = [FlickrPhoto]()
        for i in 0..<rowCount {
            list.append(FlickrPhoto(title: "title \(i)", description: "description \(i)", photoId: String(i)))
        }
        return list
    }

    class StubCurrentPhotoPort : FlickrAppCurrentPhotoPort {
        var photo: FlickrPhoto!
        func currentPhotoUpdated(photo: FlickrPhoto) {
            self.photo = photo
        }
    }
}
