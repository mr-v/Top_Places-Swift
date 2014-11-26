//
//  JSONService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

protocol JSONService {
    func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ())
}

protocol ImageService {
    func fetchImage(urlString: String, completionHandler: Result<UIImage> -> ())
    func fetchImage(url: NSURL, completionHandler: Result<UIImage> -> ())
}
