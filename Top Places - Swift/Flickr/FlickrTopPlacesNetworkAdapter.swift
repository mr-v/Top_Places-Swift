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
    }

    private let app: FlickrApp

    init(app: FlickrApp) {
        self.app = app
    }

    func updateWithJSONObject(json: NSDictionary){
        let places = json.valueForKeyPath("places.place") as [NSDictionary]
        var result = [String: [FlickrPlace]]()
        for place in places {
            var components = (place[FlickrResponseKey.Content.rawValue] as String).componentsSeparatedByString(", ")
            let country = components.removeLast()
            let placeName = components.removeAtIndex(0)
            let description = ", ".join(components)
            var placesInCountry: [FlickrPlace] = result[country] ?? [FlickrPlace]()
            placesInCountry.append(FlickrPlace(name: placeName, description: description))
            result[country] = placesInCountry
        }
        app.topPlaces = result
    }
}

