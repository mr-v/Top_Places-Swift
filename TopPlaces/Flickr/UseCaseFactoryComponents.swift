//
//  UseCaseFactoryParametersComponents.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

let CompletionHandlerUseCaseKey = "completionHandler"
let PlaceIdUseCaseKey = "placeId"
let PhotoIdUseCaseKey = "photoId"

class UseCaseFactoryParametersComponents {
    private(set) var parameters = [String: Any]()

    func photoId(id: String) -> UseCaseFactoryParametersComponents {
        parameters[PhotoIdUseCaseKey] = id
        return self
    }

    func completionHandler<T>(completionHandler: (Result<T>) -> ()) -> UseCaseFactoryParametersComponents {
        parameters[CompletionHandlerUseCaseKey] = completionHandler
        return self
    }

    func placeId(id: String) -> UseCaseFactoryParametersComponents {
        parameters[PlaceIdUseCaseKey] = id
        return self
    }
}
