//
//  FlickrSelectedPhotosHistoryTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

class FlickrSelectedPhotosHistoryTests: XCTestCase {

    var historyWithMockStore = FlickrSelectedPhotosHistory(store: MockStore()) // initializer runs before each test

    // MARK: -

    func test_CurrentPhotoUpdated_AddPhoto_AddsNewPhotoToHistory() {
        let photo = makePhotos()[0]

        historyWithMockStore.currentPhotoUpdated(photo)

        XCTAssertEqual(photo, historyWithMockStore.lastPickedPhotos[0])
    }

    func test_CurrentPhotoUpdated_AddPhotosOverLimitToHistory_HistoryDoesntGrowOverLimit() {
        let photos = makePhotos(count: historyWithMockStore.picksLimit + 1)

        for photo in photos { historyWithMockStore.currentPhotoUpdated(photo) }

        XCTAssertEqual(historyWithMockStore.picksLimit, historyWithMockStore.lastPickedPhotos.count)
    }

    func test_CurrentPhotoUpdates_AddPhotos_PhotosAreStoredInChronologicalOrder() {
        let photos = makePhotos(count: 3)

        for photo in photos { historyWithMockStore.currentPhotoUpdated(photo) }
        
        XCTAssertEqual(reverse(photos), historyWithMockStore.lastPickedPhotos)
    }

    func test_CurrentPhotoUpdates_AddSinglePhotoMultipleTimes_HistoryDoesntHaveDuplicatedEntries() {
        let photos = makePhotos(count: 3)
        let multipleTimesPickedPhoto = photos[0]

        for photo in photos { historyWithMockStore.currentPhotoUpdated(photo) }
        historyWithMockStore.currentPhotoUpdated(multipleTimesPickedPhoto)

        let result = historyWithMockStore.lastPickedPhotos.filter { $0 == multipleTimesPickedPhoto }
        XCTAssertEqual([multipleTimesPickedPhoto], result)
    }

    func test_CurrentPhotoUpdates_AddSinglePhotoMultipleTimes_PhotosAreStoredInChronologicalOrder() {
        let photos = makePhotos(count: 3)
        let multipleTimesPickedPhoto = photos[0]

        for photo in photos { historyWithMockStore.currentPhotoUpdated(photo) }
        historyWithMockStore.currentPhotoUpdated(multipleTimesPickedPhoto)
        let expected = [multipleTimesPickedPhoto, photos[2], photos[1]]

        XCTAssertEqual(expected, historyWithMockStore.lastPickedPhotos)
    }

    // MARK: - User Defaults

    func makeHistoryWithDefaultsStore(key: String) -> FlickrSelectedPhotosHistory {
        let store = FlickrSelectedPhotosHistoryStore(defaultsKey: key)
        return FlickrSelectedPhotosHistory(store: store)
    }

    func test_Init_HistoryIsEmptyBeforeLoading() {
        XCTAssertEqual(0, makeHistoryWithDefaultsStore(__FUNCTION__).lastPickedPhotos.count)
    }

    func test_LoadHistory_BackedByDefaultsStore_LoadsPhotos() {
        var firstHistory: FlickrSelectedPhotosHistory! = makeHistoryWithDefaultsStore(__FUNCTION__)

        for photo in makePhotos(count: 3) { firstHistory.currentPhotoUpdated(photo) }
        let expected = firstHistory.lastPickedPhotos
        firstHistory = nil

        var secondHistory = makeHistoryWithDefaultsStore(__FUNCTION__)
        secondHistory.loadHistory()

        XCTAssertEqual(expected, secondHistory.lastPickedPhotos)
    }

    func test_LoadHistory_NoHistoryBackedByDefaultsStore_SetsEmptyArray() {
        var history: FlickrSelectedPhotosHistory! = makeHistoryWithDefaultsStore(__FUNCTION__)

        history.loadHistory()

        XCTAssertTrue(history.lastPickedPhotos.isEmpty)
    }
}

// MARK: -

class MockStore: FlickrSelectedPhotosHistoryStore {
    override func storeHistory(photos: [FlickrPhoto]) { }
}

func makePhotos(count: Int = 1) -> [FlickrPhoto] {
    return (0..<count).map { FlickrPhoto(title: "title \($0)", description: "description \($0)", photoId: String($0)) }
}
