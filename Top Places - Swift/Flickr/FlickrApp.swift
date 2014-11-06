//
//  FlickrTopPlaces.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

struct FlickrPlace: Equatable {
    let name: String
    let description: String
    let placeId: String
}

func ==(lhs: FlickrPlace, rhs: FlickrPlace) -> Bool{
    return lhs.name == rhs.name && lhs.description == lhs.description
}

struct FlickrPhoto: Equatable {
    let title: String
    let description: String
    let photoId: String
}

func ==(lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
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

protocol FlickrAppCurrentPhotoPort: class {          // class-only protocol - makes possible to compare objects
    func currentPhotoUpdated(photo: FlickrPhoto)
}


// https://devforums.apple.com/message/981483#981483
struct WeakContainer<T where T: FlickrAppCurrentPhotoPort> {
    weak var _value : T?

    init (value: T) {
        _value = value
    }

    func get() -> T? {
        return _value
    }
}

class FlickrApp {
    var topPlaces: [String: [FlickrPlace]] {
        didSet {
            for port in topPlacesPorts {
                port.didUpdateTopPlaces()
            }
        }
    }
    var photos = [String: [FlickrPhoto]]()
    var topPlacesPorts = [FlickrAppTopPlacesPort]()
    var photosPorts = [FlickrAppPlacePhotosPort]()
    var pickedPhotoURLPort: FlickrAppPickedPhotoURLPort?
    var currentPhotoPorts = [FlickrAppCurrentPhotoPort]()

    init() {
        topPlaces = [String: [FlickrPlace]]()
    }

    func setPhotosForPlace(placeId: String, photos: [FlickrPhoto]) {
        self.photos[placeId] = photos
        for port in photosPorts {
            port.didUpdatePhotosForPlace(placeId)
        }
    }

    func updatePickedPhotoURL(url: NSURL) {
        pickedPhotoURLPort?.didUpdatePickedPhotoURL(url)
    }

    func updateCurrentPhoto(photo: FlickrPhoto) {
        for port in currentPhotoPorts {
            port.currentPhotoUpdated(photo)
        }
    }
}
