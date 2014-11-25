//
//  File.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class FlickrAppNetworkAdapter {

    private let app: FlickrApp

    init(app: FlickrApp) {
        self.app = app
    }

    //  URL formats: https://www.flickr.com/services/api/misc.urls.html
    func updatePickedPhotoURL(json: NSDictionary, callback: URLCallback) {
        let sizes = json.valueForKeyPath("sizes.size") as [NSDictionary]
        var biggestURLString = sizes.last!["source"] as String
        let regex = "^.*_o.(jpg|png|gif)$"
        if let index = biggestURLString.rangeOfString(regex, options: .RegularExpressionSearch) {
            if sizes.count >= 2 {
                biggestURLString = sizes[sizes.count - 2]["source"] as String
            }
        }
        let url = NSURL(string: biggestURLString)!
        callback(url: url)
    }
}

