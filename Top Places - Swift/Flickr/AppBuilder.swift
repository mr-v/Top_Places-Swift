//
//  ApplicationBuilder.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 31/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

// wires up application's object graph

class AppBuilder: UIStoryboardInjector {

    let app: FlickrApp
    let service: FlickrService
    let imageService: FlickrImageService
    let topPlacesViewModel: FlickrTopPlacesViewModel
    let splitControllerDelegate: FlickrSplitViewControllerDelegate
    let history: FlickrSelectedPhotosHistory

    override init() {
        app = FlickrApp()
        service = FlickrService(adapter: FlickrAppNetworkAdapter(app: app))
        imageService = FlickrImageService()
        splitControllerDelegate = FlickrSplitViewControllerDelegate()
        topPlacesViewModel = FlickrTopPlacesViewModel(app: app)
        app.topPlacesPorts.append(topPlacesViewModel)
        history = FlickrSelectedPhotosHistory(store: FlickrSelectedPhotosHistoryStore())
        app.currentPhotoPort = history
        super.init()
        setupViewControllerDependencies()
    }

    private func setupViewControllerDependencies() {
        controllerDependencies["TopPlaces"] =  { [unowned self] in
            let vc = $0 as TopPlacesTableViewController
            vc.dataSource = self.topPlacesViewModel
            vc.flickrService = self.service
            self.app.topPlacesPorts.append(vc)

            vc.splitViewController?.preferredDisplayMode = .AllVisible
        }

        controllerDependencies["Photos"] =  { [unowned self] in
            let vc = $0 as PhotosViewController
            vc.dataSource = FlickrPhotosViewModel(app: self.app)
            vc.flickrService = self.service
            self.app.photosPorts.append(vc)
            vc.imageController = self.makeImageViewControllerWithStoryBoard(vc.storyboard!)
        }

        controllerDependencies["Image"] =  { [unowned self] in
            let vc = $0 as ImageViewController
            vc.flickrService = self.service
            vc.imageService = self.imageService
        }

        let splitSetup: UIViewControllerInjector = { [unowned self] in
            let vc = $0 as UISplitViewController
            vc.delegate = self.splitControllerDelegate
        }
        controllerDependencies["Split"] = splitSetup
        controllerDependencies["SplitHistory"] = splitSetup

        controllerDependencies["History"] = { [unowned self] in
            let vc = $0 as HistoryTableViewController
            vc.dataSource = FlickrSelectedPhotosHistoryViewModel(app: self.app, history: self.history)
            vc.splitViewController?.preferredDisplayMode = .AllVisible
            vc.imageController = self.makeImageViewControllerWithStoryBoard(vc.storyboard!)
        }
    }

    private func makeImageViewControllerWithStoryBoard(storyboard: UIStoryboard) -> ImageViewController {
        return storyboard.instantiateViewControllerWithIdentifier("Image") as ImageViewController
    }
}
