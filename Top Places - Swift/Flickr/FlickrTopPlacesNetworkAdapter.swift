//
//  File.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FlickrAppNetworkAdapter {

    private let app: FlickrApp

    init(app: FlickrApp) {
        self.app = app
    }

    func updateTopPlacesWithJSONObject(json: NSDictionary) {
        let places = json.valueForKeyPath("places.place") as [NSDictionary]
        var result = [String: [FlickrPlace]]()
        for place in places {
            let content = place[FlickrResponseContentKey] as String
            let commaRange = content.rangeOfString(", ", options: .BackwardsSearch)
            let country = content.substringFromIndex(commaRange!.endIndex)
            var placesInCountry = result[country] ?? [FlickrPlace]()
            placesInCountry.append(FlickrPlace(jsonObject: place))
            result[country] = placesInCountry
        }
        app.topPlaces = result
    }

    let FlickrResponsePhotoDescriptionKey = "description._content"

    func updatePhotosFromPlace(placeId: String, json: NSDictionary) {
        let photos = json.valueForKeyPath("photos.photo") as [NSDictionary]
        var result = [FlickrPhoto]()
        for photo in photos {
            var title = photo["title"] as String
            var description = photo.valueForKeyPath(FlickrResponsePhotoDescriptionKey) as String
            switch (title, description) {
            case  ("", let d) where !d.isEmpty:
                title = description
                description = ""
            case ("", ""):
                title = "Unknown"
            default:
                false
            }
            let photoId = photo["id"] as String
            result.append(FlickrPhoto(title: title, description: description, photoId: photoId))
        }
        app.setPhotosForPlace(placeId, photos: result)
    }

    //  URL formats: https://www.flickr.com/services/api/misc.urls.html
    func updatePickedPhotoURL(json: NSDictionary, callback: URLCallback) {
        let sizes = json.valueForKeyPath("sizes.size") as [NSDictionary]
        var biggestURLString = sizes.last!["source"] as String
        let regex = "^.*_o.(jpg|png|gif)$"
        if let index = biggestURLString.rangeOfString(regex, options: .RegularExpressionSearch) {
            if sizes.count >= 2 {
                biggestURLString = sizes[sizes.count - 2]["source"] as String
            }
        }
        let url = NSURL(string: biggestURLString)!
        callback(url: url)
    }
}

