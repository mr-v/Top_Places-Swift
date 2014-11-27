//
//  Factory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

// MARK: Place JSON stubs
func makeStubTopPlaceJSONObject() -> NSDictionary {
    return [ "place_id": "hP_s5s9VVr5Qcg", "woeid": "44418", "latitude": 51.506, "longitude": -0.127, "place_url": "/United+Kingdom/England/London", "place_type": "locality", "place_type_id": 7, "timezone": "Europe/London", "_content": "London, England, United Kingdom", "woe_name": "London", "photo_count": "1734" ] as NSDictionary
}

func makeStubTopPlacesJSONResponse() -> NSDictionary {
    return ["places": ["total": 1, "place":[makeStubTopPlaceJSONObject()]]] as NSDictionary
}


// MARK: - Photo JSON stubs

let photoTitle = "London Bus Trail, New Routemaster By Candida Boyes"
let photoDescription = "Year of the Bus Sculpture Trails, 26-10-2014"
let photoId = "15487869898"

func makePhotoJSONFrom(jsonSource: NSDictionary) -> NSDictionary {
    let photos = jsonSource.valueForKeyPath("photos.photo") as [NSDictionary]
    return photos[0]
}

func makeStubPhotoSearchJSONObject() -> NSDictionary {
    return makeStubPhotoSearchJSONObjectWithTitle(photoTitle, photoDescription)
}

func makeStubPhotoSearchJSONObjectWithNoTitle() -> NSDictionary {
    return makeStubPhotoSearchJSONObjectWithTitle("", photoDescription)
}

func makeStubPhotoSearchJSONObjectWithNoTitleAndNoDescription() -> NSDictionary {
    return makeStubPhotoSearchJSONObjectWithTitle("", "")
}

func makeStubPhotoSearchJSONObjectWithTitle(title: String, description: String) -> NSDictionary {
    return ["photos": [ "page": 1, "pages": "5839580", "perpage": 1, "total": "5839580",
        "photo": [
            [ "id": "15487869898", "owner": "95012874@N00", "secret": "878261a9b2", "server": "3938", "farm": 4, "title": title, "ispublic": 1, "isfriend": 0, "isfamily": 0,
                "description": [ "_content": description ]]]]] as NSDictionary
}


// MARK: - Sizes JSON stubs

func makeStubSizesWithOriginalPhotoSize() -> [NSDictionary] {
    return makeStubSizesForPhotoJSONResponseWithOriginalPhoto().valueForKeyPath("sizes.size") as [NSDictionary]
}

func makeStubSizes() -> [NSDictionary] {
    return makeStubSizesForPhotoJSONResponse().valueForKeyPath("sizes.size") as [NSDictionary]
}

func makeStubSizesForPhotoJSONResponse() -> NSDictionary {
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

func makeStubSizesForPhotoJSONResponseWithOriginalPhoto() -> NSDictionary {
    var stubJSONObject = makeStubSizesForPhotoJSONResponse()
    var sizes = stubJSONObject.valueForKeyPath("sizes.size") as [NSDictionary]
    let original: NSDictionary = [ "label": "Medium 640", "width": "640", "height": "480", "source": "https://farm1.staticflickr.com/2/1418878_1e92283336_o.jpg", "url": "https://www.flickr.com/photos/bees/1418878/sizes/z/", "media": "photo" ]
    sizes.append(original)
    return ["sizes": ["size": sizes]]
}
