//
//  UpdatePhotosForPlace.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias CompletionHandlerForPhotosResult = (Result<(String, [Photo])>) -> ()

class UpdatePhotosForPlace: AsyncUseCase {
    private let completionHandler: CompletionHandlerForPhotosResult
    private let service: JSONService
    private let placeId: String

    init(placeId: String, service: JSONService, completionHandler: CompletionHandlerForPhotosResult) {
        self.placeId = placeId
        self.service = service
        self.completionHandler = completionHandler
    }

    // https://www.flickr.com/services/api/flickr.photos.search.html
    override func execute() {
        let photoLimit = 50
        let parameters: [String: Any] = ["method": "flickr.photos.search",
            "place_id": placeId,
            "per_page": photoLimit,
            "extras": "description"]
        let cancelable = service.fetchJSON(parameters, onCompletion)
        setTaskInprogress(cancelable)
    }

    func onCompletion(data: Result<NSDictionary>) {
        switch data {
        case .OK(let json):
            let photosJSON = json.valueForKeyPath("photos.photo") as [NSDictionary]
            let photos = photosJSON.map { data in Photo(jsonObject: data) }
            completionHandler(.OK(placeId, photos))
        case .Error:
            completionHandler(.Error)
        }
    }
}
