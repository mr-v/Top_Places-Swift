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

struct FlickrPhoto {
    let title: String
    let description: String
}

protocol FlickrAppTopPlacesPort {
    func didUpdateTopPlaces()
}

protocol FlickrAppPlacePhotosPort {
    func didUpdatePhotosForPlace(placeId: String)
}

class FlickrApp {
    var topPlaces: Dictionary<String, [FlickrPlace]> {
        didSet {
            for port in topPlacesPorts {
                port.didUpdateTopPlaces()
            }
        }
    }
    private(set) var photos: [String: [FlickrPhoto]]
    var topPlacesPorts: [FlickrAppTopPlacesPort]
    var photosPorts: [String: [FlickrAppPlacePhotosPort]]

    init() {
        topPlaces = [String: [FlickrPlace]]()
        photos = [String: [FlickrPhoto]]()
        topPlacesPorts = []
        photosPorts = [String: [FlickrAppPlacePhotosPort]]()
    }

    func setPhotosForPlace(placeId: String, photos: [FlickrPhoto]) {
        self.photos[placeId] = photos
        if let photoPorts = photosPorts[placeId] {
            for port in photoPorts {
                port.didUpdatePhotosForPlace(placeId)
            }
        }
    }
}
