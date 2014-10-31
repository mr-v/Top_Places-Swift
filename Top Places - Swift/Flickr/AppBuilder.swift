//
//  ApplicationBuilder.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 31/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class AppBuilder {

    func buildAppWithRootViewController(controller: TopPlacesTableViewController) {
        let app = FlickrApp()
        let topPlacesViewModel = FlickrTopPlacesViewModel(app: app)
        app.topPlacesPorts.append(topPlacesViewModel)
        controller.dataSource = topPlacesViewModel
        controller.flickrService = FlickrService(adapter: FlickrAppNetworkAdapter(app: app))
        app.topPlacesPorts.append(controller)
    }
}
