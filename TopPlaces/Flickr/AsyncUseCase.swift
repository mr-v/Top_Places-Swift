//
//  AsyncUseCase.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

protocol Cancelable: class {
    func cancel()
}

// enforce Cancelable protocol conformance
extension NSURLSessionDataTask: Cancelable {
    public override func cancel() {
        super.cancel()
    }
}

class AsyncUseCase: UseCase {
    weak private var cancelable: Cancelable?

    init() {
        // Clang made me to do it, otherwise there's compilation error in the subclass
    }

    func execute() {
        fatalError("this method must be overriden")
    }

    func setTaskInprogress(cancelable: Cancelable) {
        self.cancelable = cancelable
    }

    func cancel() {
        cancelable?.cancel()
    }
}
