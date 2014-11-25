//
//  SelectedPhotosHistory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class SelectedPhotosHistory: FlickrAppCurrentPhotoPort {
    let picksLimit = 20
    private(set) var lastPickedPhotos: [Photo]
    private let store: SelectedPhotosHistoryStore

    init(store: SelectedPhotosHistoryStore) {
        lastPickedPhotos = [Photo]()
        self.store = store
    }

    func currentPhotoUpdated(photo: Photo) {
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

class SelectedPhotosHistoryStore {
    let photosKey = "photos"
    let titleKey = "title"
    let descriptionKey = "description"
    let photoIdKey = "photoIdKey"
    let defaults: NSUserDefaults

    init(defaultsKey: String? = nil) {
        defaults = defaultsKey? == nil ? NSUserDefaults.standardUserDefaults() : NSUserDefaults(suiteName: defaultsKey!)!
    }

    func storeHistory(photos: [Photo]) {
        let photosAsObjects = photos.map { [self.titleKey: $0.title, self.descriptionKey: $0.description, self.photoIdKey: $0.photoId ] }
        defaults.setObject(photosAsObjects, forKey: photosKey)
    }

    func loadHistory() -> [Photo] {
        let objects = defaults.objectForKey(photosKey) as? Array<[String: String]>
        return objects?.map { Photo(title: $0[self.titleKey]!, description: $0[self.descriptionKey]!, photoId: $0[self.photoIdKey]!) } ?? []
    }
}