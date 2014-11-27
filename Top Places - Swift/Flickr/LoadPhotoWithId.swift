//
//  LoadPhotoWithId.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

typealias CompletionHandlerForLoadImageResult = (Result<UIImage>) -> ()

class LoadPhotoWithId: AsyncUseCase {
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
    override func execute() {
        let parameters: [String: Any] = ["method": "flickr.photos.getSizes", "photo_id": photoId]
        let cancelable = service.fetchJSON(parameters, completionHandler: makeSizesFetchedHandler())
        setTaskInprogress(cancelable)
    }

    private func makeSizesFetchedHandler() -> (Result<NSDictionary>) -> () {
        return { [weak self] result in
            switch result {
            case .OK(let data):
                let sizes = data.valueForKeyPath("sizes.size") as [NSDictionary]
                if let url = NSURL(sizesJSONObject: sizes) {
                    self?.loadImage(url)
                } else {
                    self?.completionHandler(.Error)
                }
            case .Error:
                self?.completionHandler(.Error)
            }
        }
    }

    private func loadImage(url: NSURL) {
        let cancelable = imageService.fetchImage(url) { [weak self] result in
            self?.completionHandler(result)
            return
        }
        setTaskInprogress(cancelable)
    }
}
