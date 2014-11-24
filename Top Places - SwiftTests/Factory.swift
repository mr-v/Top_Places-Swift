//
//  Factory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

func stubTopPlaceJSONObject() -> NSDictionary {
    return [ "place_id": "hP_s5s9VVr5Qcg", "woeid": "44418", "latitude": 51.506, "longitude": -0.127, "place_url": "/United+Kingdom/England/London", "place_type": "locality", "place_type_id": 7, "timezone": "Europe/London", "_content": "London, England, United Kingdom", "woe_name": "London", "photo_count": "1734" ] as NSDictionary
}

func stubTopPlacesJSONResponse() -> NSDictionary {
    return ["places": ["total": 1, "place":[stubTopPlaceJSONObject()]]] as NSDictionary
}