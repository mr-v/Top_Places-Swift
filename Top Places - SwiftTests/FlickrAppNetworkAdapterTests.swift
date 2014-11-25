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

    // MARK: - photos

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

    func test_UpdatePhotosFromPlace_ExtractsPhotoId() {
        let (app, adapter) = makeNetworkAdapter()

        adapter.updatePhotosFromPlace(placeId, json: stubPhotoSearchJSONObjectWithNoTitleAndNoDescription())

        let photo = app.photos[placeId]!.first!
        XCTAssertEqual("15487869898", photo.photoId)
    }

    // MARK: - Sizes

    func test_UpdatePickedPhotoURL_InvokesCallbackWithBiggestSizeURL() {
        let (_, adapter) = makeNetworkAdapter()

        adapter.updatePickedPhotoURL(stubSizesForPhoto()) {
            XCTAssertEqual(NSURL(string: "https://farm1.staticflickr.com/2/1418878_1e92283336_z.jpg?zz=1")!, $0)
        }
    }

    func test_UpdatePickedPhotoURL_SizesContainsOriginalPhoto_InvokesCallbackWitPreviousBiggestSizeURL() {
        let (_, adapter) = makeNetworkAdapter()

        adapter.updatePickedPhotoURL(stubSizesWithOriginalForPhoto()) {
            XCTAssertEqual(NSURL(string: "https://farm1.staticflickr.com/2/1418878_1e92283336_z.jpg?zz=1")!, $0)
        }
    }

    // MARK: - test utilities

    let placeId = "hP_s5s9VVr5Qcg"

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

    func stubSizesForPhoto() -> NSDictionary {
        return [ "sizes": [ "canblog": 0, "canprint": 0, "candownload": 0,
            "size": [
                [ "label": "Square", "width": 75, "height": 75, "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_s.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/sq/", "media": "photo" ],
                [ "label": "Large Square", "width": "150", "height": "150", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_q.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/q/", "media": "photo" ],
                [ "label": "Thumbnail", "width": 100, "height": 75, "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_t.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/t/", "media": "photo" ],
                [ "label": "Small", "width": "240", "height": "180", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/s/", "media": "photo" ],
                [ "label": "Medium", "width": "500", "height": "375", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/m/", "media": "photo" ],
                [ "label": "Medium 640", "width": "640", "height": "480", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_z.jpg?zz=1", "url": "https://www.flickr.com/photos/bees/1418878/sizes/z/", "media": "photo" ]
        ] ], "stat": "ok" ]
    }

    func stubSizesWithOriginalForPhoto() -> NSDictionary {
        var stubJSONObject = stubSizesForPhoto()
        var sizes = stubJSONObject.valueForKeyPath("sizes.size") as [NSDictionary]
        let original: NSDictionary = [ "label": "Medium 640", "width": "640", "height": "480", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_o.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/z/", "media": "photo" ]
        sizes.append(original)
        return ["sizes": ["size": sizes]]
    }

}
