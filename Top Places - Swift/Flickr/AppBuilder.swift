//
//  ApplicationBuilder.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 31/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import Foundation

class AppBuilder: UIStoryboardInjector {

    let app: FlickrApp
    let service: FlickrService
    let imageService: FlickrImageService
    let topPlacesViewModel: FlickrTopPlacesViewModel

    override init() {
        app = FlickrApp()
        topPlacesViewModel = FlickrTopPlacesViewModel(app: app)
        app.topPlacesPorts.append(topPlacesViewModel)
        service = FlickrService(adapter: FlickrAppNetworkAdapter(app: app))
        imageService = FlickrImageService()
        super.init()
        setupViewControllerDependencies()
    }

    private func setupViewControllerDependencies() {
        controllerDependencies["TopPlaces"] =  { [unowned self] in
            let vc = $0 as TopPlacesTableViewController
            vc.dataSource = self.topPlacesViewModel
            vc.flickrService = self.service
            self.app.topPlacesPorts.append(vc)
        }

        controllerDependencies["Photos"] =  { [unowned self] in
            let vc = $0 as PhotosViewController
            vc.dataSource = FlickrPhotosViewModel(app: self.app)
            vc.flickrService = self.service
            self.app.photosPorts.append(vc)
        }

        controllerDependencies["Image"] =  { [unowned self] in
            let vc = $0 as ImageViewController
            vc.flickrService = self.service
            vc.imageService = self.imageService
            self.app.pickedPhotoURLPort = vc
            self.app.currentPhotoPort = vc
        }
    }
}
