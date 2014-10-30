//
//  FlickrTopPlaces.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

struct FlickrPlace {
    let name: String
    let description: String
}

protocol FlickrAppPort {
    func topPlacesUpdated()
}

class FlickrApp {
    var topPlaces: Dictionary<String, [FlickrPlace]> {
        didSet {
            for port in ports {
                port.topPlacesUpdated()
            }
        }
    }
    var ports: [FlickrAppPort]

    init(port: FlickrAppPort? = nil) {
        topPlaces = [String: [FlickrPlace]]()
        self.ports = port != nil ? [port!] : []
    }
}
