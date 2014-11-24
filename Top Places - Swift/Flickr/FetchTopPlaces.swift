//
//  FetchTopPlaces.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FetchTopPlaces {
    typealias ResultFlickrPlaceCompletionHandler = (Result<[FlickrPlace]>) -> ()

    private let completionHandler: ResultFlickrPlaceCompletionHandler
    private let service: IService

    init(service: IService, completionHandler: ResultFlickrPlaceCompletionHandler) {
        self.service = service
        self.completionHandler = completionHandler
    }

    func execute() {
        service.fetchJSON(onCompletion)
    }

    func onCompletion(data: Result<NSDictionary>) {
        switch data {
        case .OK(_):
            completionHandler(.OK([]))
        case .Error:
            completionHandler(.Error)
        }
    }
}

