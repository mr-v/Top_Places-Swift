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