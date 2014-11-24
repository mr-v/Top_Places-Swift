//
//  IService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

protocol IService {
    func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ())
}
