//
//  AsyncUseCaseTests.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

//import Cocoa
import XCTest

class AsyncUseCaseTests: XCTestCase {

    func test_Cancel_CancelableObjectGetsCanceled() {
        let useCase = FakeAsyncUseCase()

        useCase.execute()
        useCase.cancel()

        XCTAssertTrue(useCase.cancelMock!.canceled)
    }
}

private class FakeAsyncUseCase: AsyncUseCase {
    private(set) var cancelMock: CancelableTestDouble?

    override func execute() {
        cancelMock = CancelableTestDouble()
        setTaskInprogress(cancelMock!)
    }
}