//
//  PhotosViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class PhotosViewModelTests: XCTestCase {

    // MARK: - data source

    func test_NumberOfRowsInSection() {
        let (_, viewModel) = makeViewModel()

        viewModel.updatePhotos()

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 2)
        XCTAssertEqual(rowCount, result)
    }

    func test_DidSelectPhotoAtIndexPath_UpdatesCurrentPhotoPort() {
        let (app, viewModel) = makeViewModel()
        let port = StubCurrentPhotoPort()
        app.currentPhotoPort = port

        let (id, photos) = makeTestPhotos()
        app.photos[id] = photos
        viewModel.didSelectPhotoAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertEqual(Photo(title: "title 0", description: "description 0", photoId: "0"), port.photo)
    }

    // TODO: - test cell configuration


//  MARK: -

    private let rowCount = 5
    private let placeId = "0"

    private func makeViewModel() -> (FlickrApp, PhotosViewModel) {
        let app = FlickrApp()
        let result = Result.OK(makeTestPhotos())

        let viewModel = PhotosViewModel(app: app, useCaseFactory: StubUseCaseFactory(result: result))
        viewModel.placeId = placeId
        return (app, viewModel)
    }

    private func makeTestPhotos() -> (String, [Photo]) {
        var list = [Photo]()
        for i in 0..<rowCount {
            list.append(Photo(title: "title \(i)", description: "description \(i)", photoId: String(i)))
        }
        return ("0", list)
    }

    class StubCurrentPhotoPort : FlickrAppCurrentPhotoPort {
        var photo: Photo!
        func currentPhotoUpdated(photo: Photo) {
            self.photo = photo
        }
    }
}
