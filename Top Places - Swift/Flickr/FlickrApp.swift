//
//  FlickrTopPlaces.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

struct Place: Equatable {
    let name: String
    let description: String
    let placeId: String
}

func ==(lhs: Place, rhs: Place) -> Bool{
    return lhs.name == rhs.name && lhs.description == lhs.description
}

struct Photo: Equatable {
    let title: String
    let description: String
    let photoId: String
}

func ==(lhs: Photo, rhs: Photo) -> Bool {
    return lhs.photoId == rhs.photoId
}

protocol FlickrAppTopPlacesPort {
    func didUpdateTopPlaces()
}

protocol FlickrAppPlacePhotosPort {
    func didUpdatePhotosForPlace(placeId: String)
}

protocol FlickrAppPickedPhotoURLPort {
    func didUpdatePickedPhotoURL(url: NSURL)
}

protocol FlickrAppCurrentPhotoPort {
    func currentPhotoUpdated(photo: Photo)
}

class FlickrApp {
    var topPlaces: [String: [Place]] {
        didSet {
            for port in topPlacesPorts {
                port.didUpdateTopPlaces()
            }
        }
    }
    var photos = [String: [Photo]]()
    var topPlacesPorts = [FlickrAppTopPlacesPort]()
    var photosPorts = [FlickrAppPlacePhotosPort]()
    var currentPhotoPort: FlickrAppCurrentPhotoPort?

    init() {
        topPlaces = [String: [Place]]()
    }

    func setPhotosForPlace(placeId: String, photos: [Photo]) {
        self.photos[placeId] = photos
        for port in photosPorts {
            port.didUpdatePhotosForPlace(placeId)
        }
    }

    func updateCurrentPhoto(photo: Photo) {
        currentPhotoPort?.currentPhotoUpdated(photo)
    }
}
