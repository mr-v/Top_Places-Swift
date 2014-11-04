//
//  FlickrTopPlacesViewModelTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrTopPlacesViewModelTests: XCTestCase {

    // TODO: - empty

    func test_didUpdateTopPlaces_CreatesSectionToNameMapping() {
        let (app, viewModel) = makeViewModel()

        app.topPlaces = makeTestTopPlaces()

        let result = viewModel.sectionToName
        XCTAssertEqual(["Brazil", "Canada", "United Kingdom"], result)
    }

    // MARK: - data source

    func test_NumberOfSectionsInTableView() {
        let (app, viewModel) = makeViewModel()

        app.topPlaces = makeTestTopPlaces()

        let result = viewModel.numberOfSectionsInTableView(UITableView())
        XCTAssertEqual(3, result)
    }

    func test_NumberOfRowsInSection() {
        let (app, viewModel) = makeViewModel()

        app.topPlaces = makeTestTopPlaces()

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 2)
        XCTAssertEqual(2, result)
    }

    func test_TitleForHeaderInSection() {
        let (app, viewModel) = makeViewModel()

        app.topPlaces = makeTestTopPlaces()

        let result = viewModel.tableView(UITableView(), titleForHeaderInSection: 2)!
        XCTAssertEqual("United Kingdom", result)
    }

    func test_PlaceForIndexPath_ReturnsPlace() {
        let (app, viewModel) = makeViewModel()

        app.topPlaces = makeTestTopPlaces()

        let result = viewModel.placeForIndexPath(NSIndexPath(forRow: 1, inSection: 2))
        XCTAssertEqual(FlickrPlace(name: "York", description: "England", placeId: "2"), result)
    }

    // MARK: -

    private func makeViewModel() -> (FlickrApp, FlickrTopPlacesViewModel) {
        let app = FlickrApp()
        let viewModel = FlickrTopPlacesViewModel(app: app)
        app.topPlacesPorts.append(viewModel)
        return (app, viewModel)
    }

    private func makeTestTopPlaces() -> Dictionary<String, [FlickrPlace]> {
        return ["United Kingdom": [FlickrPlace(name: "London", description: "England", placeId: "1"), FlickrPlace(name: "York", description: "England", placeId: "2")],
            "Brazil": [FlickrPlace(name: "Rio de Janeiro", description: "Rio de Janeiro", placeId: "#")],
            "Canada": [FlickrPlace(name: "Toronto", description: "Ontario", placeId: "4")]]
    }
}
