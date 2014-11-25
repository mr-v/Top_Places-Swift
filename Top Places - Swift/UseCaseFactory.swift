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
}

protocol UseCase {
    func execute()
}

protocol IUseCaseFactory {
    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase
}

typealias UseCaseFactoryParameters = [String: Any]

let CompletionHandlerUseCaseKey = "completionHandler"

class UseCaseFactory: IUseCaseFactory {
    private let service: IService

    init(service: IService) {
        self.service = service
    }

    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase {
        switch type {
        case .UpdateTopPlaces:
            let completionHandler = parameters[CompletionHandlerUseCaseKey] as ResultFlickrPlaceCompletionHandler
            return UpdateTopPlaces(service: service, completionHandler: completionHandler)
        }
    }
}