//
//  FlickrJSONInitializers.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

let FlickrResponseContentKey = "_content"
let FlickrResponsePhotoDescriptionKey = "description._content"

extension Place {
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

extension Photo {
    init(jsonObject: NSDictionary) {
        title = jsonObject["title"] as String
        description = jsonObject.valueForKeyPath(FlickrResponsePhotoDescriptionKey) as String
        switch (title, description) {
        case  ("", let d) where !d.isEmpty:
            title = description
            description = ""
        case ("", ""):
            title = "Unknown"
        default:
            false
        }
        photoId = jsonObject["id"] as String
    }
}

//  URL formats: https://www.flickr.com/services/api/misc.urls.html
extension NSURL {
    convenience init?(sizesJSONObject: [NSDictionary]) {
        func extractURLString(data: NSDictionary) -> String {
            return data["source"] as String
        }

        var biggestURLString = extractURLString(sizesJSONObject.last!)
        let originalPhotoRegex = "^.*_o.(jpg|png|gif)$"
        if let index = biggestURLString.rangeOfString(originalPhotoRegex, options: .RegularExpressionSearch) {
            if sizesJSONObject.count > 1 {
                biggestURLString = extractURLString(dropLast(sizesJSONObject).last!)
            }
        }
        self.init(string: biggestURLString)
    }
}
