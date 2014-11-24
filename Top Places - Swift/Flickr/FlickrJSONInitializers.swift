//
//  FlickrJSONInitializers.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

let FlickrResponseContentKey = "_content"

extension FlickrPlace {
    init(jsonObject: NSDictionary) {
        var placeComponents = (jsonObject[FlickrResponseContentKey] as String).componentsSeparatedByString(", ")
        placeComponents.removeLast() // remove place's country name
        let placeName = placeComponents.removeAtIndex(0)
        let placeDescription = ", ".join(placeComponents)
        let placeId = jsonObject["place_id"] as String
        name = placeName
        description = placeDescription
        self.placeId = placeId
    }
}
