//
//  File.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FlickrAppNetworkAdapter {

    enum FlickrResponseKey: String {
        case Content = "_content"
        case PhotoDescription = "description._content"
    }

    private let app: FlickrApp

    init(app: FlickrApp) {
        self.app = app
    }

    func updateTopPlacesWithJSONObject(json: NSDictionary) {
        let places = json.valueForKeyPath("places.place") as [NSDictionary]
        var result = [String: [FlickrPlace]]()
        for place in places {
            var components = (place[FlickrResponseKey.Content.rawValue] as String).componentsSeparatedByString(", ")
            let country = components.removeLast()
            let placeName = components.removeAtIndex(0)
            let description = ", ".join(components)
            let placeId = place["place_id"] as String
            var placesInCountry: [FlickrPlace] = result[country] ?? [FlickrPlace]()
            placesInCountry.append(FlickrPlace(name: placeName, description: description, placeId: placeId))
            result[country] = placesInCountry
        }
        app.topPlaces = result
    }

    func updatePhotosFromPlace(placeId: String, json: NSDictionary) {
        let photos = json.valueForKeyPath("photos.photo") as [NSDictionary]
        var result = [FlickrPhoto]()
        for photo in photos {
            var title = photo["title"] as String
            var description = photo.valueForKeyPath(FlickrResponseKey.PhotoDescription.rawValue) as String
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

    func updatePickedPhotoURL(json: NSDictionary) {
        let sizes = json.valueForKeyPath("sizes.size") as [NSDictionary]
        let biggestURLString = sizes.last!["source"] as String
        app.updatePickedPhotoURL(NSURL(string: biggestURLString)!)
    }
}

