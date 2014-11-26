//
//  LoadPhotoWithId.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias CompletionHandlerForLoadImageResult = (Result<UIImage>) -> ()

class LoadPhotoWithId: UseCase {
    private let completionHandler: CompletionHandlerForLoadImageResult
    private let service: JSONService
    private let imageService: ImageService
    private let photoId: String

    init(photoId: String, service: JSONService, imageService: ImageService, completionHandler: CompletionHandlerForLoadImageResult) {
        self.photoId = photoId
        self.service = service
        self.imageService = imageService
        self.completionHandler = completionHandler
    }

    // https://www.flickr.com/services/api/flickr.photos.getSizes.html
    func execute() {
        let parameters: [String: Any] = ["method": "flickr.photos.getSizes", "photo_id": photoId]
        service.fetchJSON(parameters, completionHandler: sizesFetched)
    }

    private func sizesFetched(result: Result<NSDictionary>) {
        switch result {
        case .OK(let data):
            let sizes = data.valueForKeyPath("sizes.size") as [NSDictionary]
            if let url = NSURL(sizesJSONObject: sizes) {
                loadImage(url)
            } else {
                completionHandler(.Error)
            }
        case .Error:
            completionHandler(.Error)
        }
    }

    private func loadImage(url: NSURL) {
        imageService.fetchImage(url) { self.completionHandler($0) }
    }
}
