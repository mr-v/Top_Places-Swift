//
//  UseCaseFactory.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

enum UseCaseType {
    case UpdateTopPlaces
    case UpdatePhotosForPlace
    case LoadPhotoWithId
}

protocol UseCase: Cancelable {
    func execute()
}

typealias UseCaseFactoryParameters = [String: Any]

protocol IUseCaseFactory {
    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase
}

class UseCaseFactory: IUseCaseFactory {
    private let service: JSONService
    private let imageService: ImageService

    init(service: JSONService, imageService: ImageService) {
        self.service = service
        self.imageService = imageService
    }

    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase {
        switch type {
        case .UpdateTopPlaces:
            let completionHandler = parameters[CompletionHandlerUseCaseKey] as CompletionHandlerForPlaceResult
            return UpdateTopPlaces(service: service, completionHandler: completionHandler)
        case .UpdatePhotosForPlace:
            let completionHandler = parameters[CompletionHandlerUseCaseKey] as CompletionHandlerForPhotosResult
            let placeId = parameters[PlaceIdUseCaseKey] as String
            return UpdatePhotosForPlace(placeId: placeId, service: service, completionHandler: completionHandler)
        case .LoadPhotoWithId:
            let photoId = parameters[PhotoIdUseCaseKey] as String
            let completionHandler = parameters[CompletionHandlerUseCaseKey] as CompletionHandlerForLoadImageResult
            return LoadPhotoWithId(photoId: photoId, service: service, imageService: imageService, completionHandler: completionHandler)
        }
    }
}