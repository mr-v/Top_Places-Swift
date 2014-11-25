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

    func makeNetworkAdapter() -> (FlickrApp, FlickrAppNetworkAdapter) {
        let app = FlickrApp()
        return (app, FlickrAppNetworkAdapter(app: app))
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
