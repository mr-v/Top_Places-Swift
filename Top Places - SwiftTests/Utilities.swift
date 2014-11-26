//
//  Utilities.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 25/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit
import XCTest

extension XCTestCase {
    func waitForExpectationsAndFailAfterTimeout(timeout: NSTimeInterval) {
        waitForExpectationsWithTimeout(timeout) {
            if let error = $0 {
                XCTFail()
            }
        }
    }
}

let StubResultUseCaseFactoryKey = "StubResultUseCaseFactoryKey"

class StubUseCaseFactory<T>: IUseCaseFactory {
    let result: Result<T>
    init(result: Result<T>) {
        self.result = result
    }

    func createWithType(type: UseCaseType, parameters: UseCaseFactoryParameters) -> UseCase {
        let completionHandler = parameters[CompletionHandlerUseCaseKey] as (Result<T>) -> ()
        return StubUseCase(result: result, completionHandler: completionHandler)
    }
}

class StubUseCase<T>: UseCase {
    let completionHandler: (Result<T>) -> ()
    let result: Result<T>

    init(result: Result<T>, completionHandler: (Result<T>) -> ()) {
        self.result = result
        self.completionHandler = completionHandler
    }

    func execute() {
        completionHandler(result)
    }
}

class StubService: JSONService {
    let response: Result<NSDictionary>

    init(response: Result<NSDictionary>) {
        self.response = response
    }

    func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ()) {
        completionHandler(response)
    }
}

class StubImageService: ImageService {
    let response: Result<UIImage>

    init(response: Result<UIImage>) {
        self.response = response
    }

    func fetchImage(urlString: String, completionHandler: Result<UIImage> -> ()) {
        completionHandler(response)
    }

    func fetchImage(url: NSURL, completionHandler: Result<UIImage> -> ()) {
        completionHandler(response)
    }
}