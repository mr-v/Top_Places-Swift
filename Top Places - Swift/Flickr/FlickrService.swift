//
//  FlickrService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

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
            jsonObject in self.adapter.updateWithJSONObject(jsonObject)
        }
    }

    private func sendRequest(parameters: String, callback: (jsonObject: NSDictionary) -> ()) {
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
                    callback(jsonObject: jsonObject)
                default:
                    fatalError("")  // TODO: - crash for development purposes, later switch to logging error
                }
            }
        }

        task.resume()
    }
}
