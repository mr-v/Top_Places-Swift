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
}

protocol UseCase {
    func execute()
}

protocol IUseCaseFactory {
    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase
}

typealias UseCaseFactoryParameters = [String: Any]

let CompletionHandlerUseCaseKey = "completionHandler"
let PlaceIdUseCaseKey = "placeId"

class UseCaseFactory: IUseCaseFactory {
    private let service: IService

    init(service: IService) {
        self.service = service
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
        }
    }
}