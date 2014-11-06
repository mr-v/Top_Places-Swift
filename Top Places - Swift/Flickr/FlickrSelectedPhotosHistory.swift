//
//  FlickrSelectedPhotosHistory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FlickrSelectedPhotosHistory: FlickrAppCurrentPhotoPort {
    let picksLimit = 20
    private(set) var lastPickedPhotos: [FlickrPhoto]
    private let store: FlickrSelectedPhotosHistoryStore

    init(store: FlickrSelectedPhotosHistoryStore) {
        lastPickedPhotos = [FlickrPhoto]()
        self.store = store
    }

    func currentPhotoUpdated(photo: FlickrPhoto) {
        if lastPickedPhotos.count == picksLimit {
            lastPickedPhotos.removeLast()
        }
        if let index = find(lastPickedPhotos, photo) {
            lastPickedPhotos.removeAtIndex(index)
        }
        lastPickedPhotos.insert(photo, atIndex: 0)
        store.storeHistory(lastPickedPhotos)
    }

    func loadHistory() {
        lastPickedPhotos = store.loadHistory()
    }
}

class FlickrSelectedPhotosHistoryStore {
    let photosKey = "photos"
    let titleKey = "title"
    let descriptionKey = "description"
    let photoIdKey = "photoIdKey"
    let defaults: NSUserDefaults

    init(defaultsKey: String? = nil) {
        defaults = defaultsKey? == nil ? NSUserDefaults.standardUserDefaults() : NSUserDefaults(suiteName: defaultsKey!)!
    }

    func storeHistory(photos: [FlickrPhoto]) {
        let photosAsObjects = photos.map { [self.titleKey: $0.title, self.descriptionKey: $0.description, self.photoIdKey: $0.photoId ] }
        defaults.setObject(photosAsObjects, forKey: photosKey)
    }

    func loadHistory() -> [FlickrPhoto] {
        let objects = defaults.objectForKey(photosKey) as? Array<[String: String]>
        return objects?.map { FlickrPhoto(title: $0[self.titleKey]!, description: $0[self.descriptionKey]!, photoId: $0[self.photoIdKey]!) } ?? []
    }
}