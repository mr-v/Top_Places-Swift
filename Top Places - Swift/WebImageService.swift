//
//  ImageService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 26/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class WebImageService: ImageService {
    private let imageSession: NSURLSession

    init() {
        let imageConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let imageCache = NSURLCache(memoryCapacity:10 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
        imageConfiguration.URLCache = imageCache
        imageSession = NSURLSession(configuration: imageConfiguration)
    }

    func fetchImage(url: NSURL, completionHandler: Result<UIImage> -> ()) {
        let request = NSURLRequest(URL: url)
        let task = imageSession.dataTaskWithRequest(request, completionHandler: { data, urlResponse, error in
            func dispatchError() {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
            }

            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    dispatchError()
                    return
                }
            }

            if let image = UIImage(data: data) {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.OK(image)) }
            } else {
                dispatchError()
            }
        })
        task.resume()
    }

    func fetchImage(urlString: String, completionHandler: Result<UIImage> -> ()) {
        let url = NSURL(string: urlString)
        if url == nil {
            dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
            return
        }
        fetchImage(url!, completionHandler: completionHandler)
    }
}