//
//  FlickrService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

/*
    for Flickr error codes see:
        https://www.flickr.com/services/api/flickr.places.getTopPlacesList.html
        https://www.flickr.com/services/api/flickr.photos.search.html
        https://www.flickr.com/services/api/flickr.photos.getSizes.html
*/

import Foundation

typealias URLCallback = (url: NSURL) -> ()

class FlickrService {
    let RESTEndpoint = "https://api.flickr.com/services/rest/"
    let APIExplorerKey: String = "8bac83dae148d108bd0ac45ca6fd07c3"
    var standardParameters: String { return "format=json&nojsoncallback=1&api_key=\(APIExplorerKey)" }
    let urlSession: NSURLSession
    let adapter: FlickrAppNetworkAdapter

    init(adapter: FlickrAppNetworkAdapter) {
        self.adapter = adapter
        urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    }

    func fetchTopPlaces() {
        let localityPlaceType = "7"
        let topPlacesParameters = "method=flickr.places.getTopPlacesList&place_type_id=\(localityPlaceType)"
        sendRequest(topPlacesParameters) {
            jsonObject in self.adapter.updateTopPlacesWithJSONObject(jsonObject)
        }
    }

    func fetchPhotosFromPlace(placeId: String) {
        let photoLimit = 50
        let photosParameters = "method=flickr.photos.search&place_id=\(placeId)&per_page=\(photoLimit)&extras=description"
        sendRequest(photosParameters) {
            jsonObject in self.adapter.updatePhotosFromPlace(placeId, json: jsonObject)
        }
    }

    func fetchSizesForPhotoId(photoId: String, callback: URLCallback) {
        let getSizesParameters = "method=flickr.photos.getSizes&photo_id=\(photoId)"
        sendRequest(getSizesParameters) {
            jsonObject in
            self.adapter.updatePickedPhotoURL(jsonObject, callback: callback)
        }
    }

    func sendRequest(parameters: String, callback: (jsonObject: NSDictionary) -> ()) {
        let urlString = RESTEndpoint + "?" + parameters + "&" + standardParameters
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)

        let task = urlSession.dataTaskWithRequest(request) {
            data, urlResponse, error in
            if error != nil {
                fatalError("")  // TODO: - crash for development purposes, later switch to logging error
            }

            if let httpResponse = urlResponse as? NSHTTPURLResponse {
                let jsonObject = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary

                // https://www.flickr.com/services/api/response.json.html
                if jsonObject["stat"] as String != "ok" {
                    fatalError("Flickr failure: \(jsonObject)")
                    return
                }

                switch httpResponse.statusCode {
                case 200, 304:
                    dispatch_async(dispatch_get_main_queue()) {
                        callback(jsonObject: jsonObject)
                    }
                    // TODO handle 400, 500 errors
                default:
                    fatalError("")  // TODO: - crash for development purposes, later switch to logging error
                }
            }
        }

        task.resume()
    }
}
