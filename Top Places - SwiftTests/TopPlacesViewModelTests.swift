//
//  TopPlacesViewModelTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class TopPlacesViewModelTests: XCTestCase {

    // MARK: - data source

    func test_NumberOfSectionsInTableView() {
        let viewModel = makeViewModel()

        viewModel.updateTopPlaces()

        let result = viewModel.numberOfSectionsInTableView(UITableView())
        XCTAssertEqual(3, result)
    }

    func test_NumberOfRowsInSection() {
        let viewModel = makeViewModel()

        viewModel.updateTopPlaces()

        let result = viewModel.tableView(UITableView(), numberOfRowsInSection: 2)
        XCTAssertEqual(2, result)
    }

    func test_TitleForHeaderInSection() {
        let viewModel = makeViewModel()

        viewModel.updateTopPlaces()

        let result = viewModel.tableView(UITableView(), titleForHeaderInSection: 2)!
        XCTAssertEqual("United Kingdom", result)
    }

    func test_PlaceForIndexPath_ReturnsPlace() {
        let viewModel = makeViewModel()

        viewModel.updateTopPlaces()

        let result = viewModel.placeForIndexPath(NSIndexPath(forRow: 1, inSection: 2))
        XCTAssertEqual(Place(name: "York", description: "England", placeId: "2"), result)
    }

    // TODO: - test cell configuration


    // MARK: -

    private func makeViewModel() -> TopPlacesViewModel {
        let app = FlickrApp()
        let result = Result.OK(makeTestTopPlaces())
        let viewModel = TopPlacesViewModel(app: app, useCaseFactory: StubUseCaseFactory(result: result))
        return viewModel
    }

    private func makeTestTopPlaces() -> [String: [Place]] {
        return ["United Kingdom": [Place(name: "London", description: "England", placeId: "1"), Place(name: "York", description: "England", placeId: "2")],
            "Brazil": [Place(name: "Rio de Janeiro", description: "Rio de Janeiro", placeId: "#")],
            "Canada": [Place(name: "Toronto", description: "Ontario", placeId: "4")]]
    }
}
