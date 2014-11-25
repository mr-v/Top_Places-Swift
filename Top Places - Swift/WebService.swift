//
//  WebService.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 24/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class WebService: IService {
    private let session: NSURLSession
    let baseURL: NSURL
    let defaultParameters: [String : Any]

    init(baseURLString: String, defaultParameters: [String: Any]) {
        let defaultConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        session = NSURLSession(configuration: defaultConfiguration)
        baseURL = NSURL(string: baseURLString)!
        self.defaultParameters = defaultParameters
    }

    func fetchJSON(parameters: [String: Any], completionHandler: Result<NSDictionary> -> ()) {
        let request = urlRequestWithParameters(parameters)
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, urlResponse, error) -> Void in
            // TODO: completion
//            if error
            var possibleError: NSError?
            var deserialized = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &possibleError) as? NSDictionary
            if let error = possibleError {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
                return
            }
            if let jsonObject = deserialized {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.OK(jsonObject)) }
            } else {
                dispatch_async(dispatch_get_main_queue()) { completionHandler(.Error) }
            }

        })
        task.resume()
    }

    private func urlRequestWithParameters(parameters: [String: Any]) -> NSURLRequest {
        let mergedParameters = defaultParameters + parameters
        let query = queryWithParameters(mergedParameters)
        let endpoint = ""
        let url = NSURL(string: endpoint + query, relativeToURL: baseURL)!
        var request = NSMutableURLRequest(URL: url)
        return request
    }

    private func queryWithParameters(parameters: [String: Any]) -> NSString {
        let keys = parameters.keys.array
        let query = "&".join(keys.map { key in "\(key)=\(parameters[key]!)"})
        return query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
}
