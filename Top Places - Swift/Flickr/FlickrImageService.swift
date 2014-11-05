//
//  FlickrImageService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FlickrImageService {
    private var currentTask:NSURLSessionTask?
    private var imageSession: NSURLSession

    init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let imageCache = NSURLCache(memoryCapacity:10 * 1024 * 1024, diskCapacity:20 * 1024 * 1024, diskPath:nil)
        configuration.URLCache = imageCache
        imageSession = NSURLSession(configuration: configuration)
    }

    func fetchImage(url: NSURL, callback: (UIImage) -> ()) {
        currentTask?.cancel()

        let request = NSURLRequest(URL: url)
        currentTask = imageSession.dataTaskWithRequest(request) {
            data, urlResponse, error in
            if error != nil {
                fatalError("")  // TODO: add error handling
            }

            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...399:
                    let image = UIImage(data: data)!
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(image)
                    }
                    //     TODO handle 400, 500 errors
                default:
                    fatalError("")
                }
            }
        }
        currentTask!.resume()
    }
}

