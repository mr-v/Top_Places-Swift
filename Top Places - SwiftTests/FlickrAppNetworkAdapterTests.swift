//
//  TopPlacesNetworkAdapterTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrAppNetworkAdapterTests: XCTestCase {

    // MARK: - places

    func test_UpdateTopPlacesWithJSONObject_UpdatesTopPlaces() {
        let (app, adapter) = makeNetworkAdapter()
        let defaultZeroCount = app.topPlaces.count

        adapter.updateTopPlacesWithJSONObject(stubTopPlacesJSONObject())

        XCTAssertNotEqual(defaultZeroCount, app.topPlaces.count)
    }

    func test_UpdateTopPlacesWithJSONObject_ExtractsCountry() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updateTopPlacesWithJSONObject(stubTopPlacesJSONObject())

        let result = app.topPlaces.keys.first!
        XCTAssertEqual("United Kingdom", result)
    }

    func test_UpdateTopPlacesWithJSONObject_ExtractsPlace() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updateTopPlacesWithJSONObject(stubTopPlacesJSONObject())

        let result = app.topPlaces["United Kingdom"]![0]
        XCTAssertEqual("London", result.name)
    }

    func test_UpdateTopPlacesWithJSONObject_ExtractsDescription() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updateTopPlacesWithJSONObject(stubTopPlacesJSONObject())

        let result = app.topPlaces["United Kingdom"]![0]
        XCTAssertEqual("England", result.description)
    }

    // MARK: - photos

    let placeId = "hP_s5s9VVr5Qcg"

    func test_UpdatePhotosFromPlace_UpdatesPhotos() {
        let (app, adapter) = makeNetworkAdapter()
        let defaultZeroCount = app.topPlaces.count

        adapter.updatePhotosFromPlace(placeId, json: stubPhotoSearchJSONObject())

        XCTAssertNotEqual(defaultZeroCount, app.photos.count)
    }

    func test_UpdatePhotosFromPlace_ExtractsTitle() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updatePhotosFromPlace(placeId, json: stubPhotoSearchJSONObject())

        let photo = app.photos[placeId]!.first!
        XCTAssertEqual(photoTitle, photo.title)
    }

    func test_UpdatePhotosFromPlace_NoTitle_UsesDescriptionAsTitle() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updatePhotosFromPlace(placeId, json: stubPhotoSearchJSONObjectWithNoTitle())

        let photo = app.photos[placeId]!.first!
        XCTAssertEqual(photoDescription, photo.title)
    }

    func test_UpdatePhotosFromPlace_NoTitleNoDescription_UsesUnknownAsTitle() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updatePhotosFromPlace(placeId, json: stubPhotoSearchJSONObjectWithNoTitleAndNoDescription())

        let photo = app.photos[placeId]!.first!
        XCTAssertEqual("Unknown", photo.title)
    }


    // MARK: - factory methods

    func makeNetworkAdapter() -> (FlickrApp, FlickrAppNetworkAdapter) {
        let app = FlickrApp()
        return (app, FlickrAppNetworkAdapter(app: app))
    }

    func stubTopPlacesJSONObject() -> NSDictionary {
        return [ "places": [ "total": 1,
            "place": [
                [ "place_id": "hP_s5s9VVr5Qcg", "woeid": "44418", "latitude": 51.506, "longitude": -0.127, "place_url": "/United+Kingdom/England/London", "place_type": "locality", "place_type_id": 7, "timezone": "Europe/London", "_content": "London, England, United Kingdom", "woe_name": "London", "photo_count": "1734" ]]]] as NSDictionary
    }

    let photoTitle = "London Bus Trail, New Routemaster By Candida Boyes"
    let photoDescription = "Year of the Bus Sculpture Trails, 26-10-2014"

    func stubPhotoSearchJSONObject() -> NSDictionary {
        return stubPhotoSearchJSONObjectWithTitle(photoTitle, description: photoDescription)
    }

    func stubPhotoSearchJSONObjectWithNoTitle() -> NSDictionary {
        return stubPhotoSearchJSONObjectWithTitle("", description: photoDescription)
    }

    func stubPhotoSearchJSONObjectWithNoTitleAndNoDescription() -> NSDictionary {
        return stubPhotoSearchJSONObjectWithTitle("", description: "")
    }

    func stubPhotoSearchJSONObjectWithTitle(title: String, description: String) -> NSDictionary {
        return ["photos": [ "page": 1, "pages": "5839580", "perpage": 1, "total": "5839580",
            "photo": [
                [ "id": "15487869898", "owner": "95012874@N00", "secret": "878261a9b2", "server": "3938", "farm": 4, "title": title, "ispublic": 1, "isfriend": 0, "isfamily": 0,
                    "description": [ "_content": description ]]]]] as NSDictionary
    }
}
