//
//  FetchTopPlaces.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FetchTopPlaces {
    typealias ResultFlickrPlaceCompletionHandler = (Result<[String: [Place]]>) -> ()

    private let completionHandler: ResultFlickrPlaceCompletionHandler
    private let service: IService

    init(service: IService, completionHandler: ResultFlickrPlaceCompletionHandler) {
        self.service = service
        self.completionHandler = completionHandler
    }

    func execute() {
        service.fetchJSON([String: AnyObject](), onCompletion)
    }

    func onCompletion(data: Result<NSDictionary>) {
        switch data {
        case .OK(let json):
            let places = json.valueForKeyPath("places.place") as [NSDictionary]
            var placesByCountry = [String: [Place]]()
            for place in places {
                let content = place[FlickrResponseContentKey] as String
                let lastCommaRange = content.rangeOfString(", ", options: .BackwardsSearch)
                let country = content.substringFromIndex(lastCommaRange!.endIndex)
                var placesInCountry = placesByCountry[country] ?? [Place]()
                placesInCountry.append(Place(jsonObject: place))
                placesByCountry[country] = placesInCountry
            }
            completionHandler(.OK(placesByCountry))
        case .Error:
            completionHandler(.Error)
        }
    }
}
