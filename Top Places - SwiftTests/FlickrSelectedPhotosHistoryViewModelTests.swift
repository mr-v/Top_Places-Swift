//
//  FlickrSelectedPhotosHistoryViewModelTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrSelectedPhotosHistoryViewModelTests: XCTestCase {

    func test_NumberOfRowsInSection_EmptyHistory_ReturnsCountOfOne() {
        let viewModel = makeViewModel(0)

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 0)

        XCTAssertEqual(1, result)
    }

    func test_NumberOfRowsInSection_NonEmptyHistory_ReturnsProperCount() {
        let count = 5
        let viewModel = makeViewModel(count)

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 0)

        XCTAssertEqual(count, result)
    }

    func test_CellForRowAtIndexPath_NoHistory_ReturnsCellWitnNoHistoryTitle() {
        let viewModel = makeViewModel(0)
        let tableView = FakeTableView()

        let cell = viewModel.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertEqual(cell.textLabel.text!, viewModel.noItemsTitle)
    }

    func test_CellForRowAtIndexPath_NoHistory_ReturnsCellWitnNoHistoryDescription() {
        let viewModel = makeViewModel(0)
        let tableView = FakeTableView()

        let cell = viewModel.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertEqual(cell.detailTextLabel!.text!, viewModel.noItemsDescription)
    }

    func test_CellForRowAtIndexPath_NoHistory_CellUserInteractionIsDisabled() {
        let viewModel = makeViewModel(0)
        let tableView = FakeTableView()

        let cell = viewModel.tableView(tableView, cellForRowAtIndexPath: NSIndexPath(forRow: 0, inSection: 0))

        XCTAssertFalse(cell.userInteractionEnabled)
    }

    // MARK: -

    func makeViewModel(count: Int) -> FlickrSelectedPhotosHistoryViewModel {
        let history = FlickrSelectedPhotosHistory(store: MockStore())
        let photos = makePhotos(count: count)
        for photo in photos { history.currentPhotoUpdated(photo) }
        let viewModel = FlickrSelectedPhotosHistoryViewModel(app: FlickrApp(), history: history)
        return viewModel
    }

    class FakeTableView: UITableView {
        override func dequeueReusableCellWithIdentifier(identifier: String, forIndexPath indexPath: NSIndexPath) -> AnyObject {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        }
    }
}
