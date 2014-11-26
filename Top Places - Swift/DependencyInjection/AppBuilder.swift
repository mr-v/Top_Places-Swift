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
    let topPlacesViewModel: TopPlacesViewModel
    let splitControllerDelegate: SplitViewControllerDelegate
    let history: SelectedPhotosHistory
    let useCaseFactory: UseCaseFactory
    let webService: WebJSONService
    let imageService: WebImageService

    override init() {
        app = FlickrApp()

        let urlString = "https://api.flickr.com/services/rest/"
        let defaultParameters: [String: Any] = ["api_key": "8bac83dae148d108bd0ac45ca6fd07c3",
            "format": "json",
            "nojsoncallback": "1"]
        webService = WebJSONService(baseURLString: urlString, defaultParameters: defaultParameters)

        imageService = WebImageService()
        useCaseFactory = UseCaseFactory(service: webService, imageService: imageService)
        splitControllerDelegate = SplitViewControllerDelegate()
        topPlacesViewModel = TopPlacesViewModel(app: app, useCaseFactory: useCaseFactory)
        history = SelectedPhotosHistory(store: SelectedPhotosHistoryStore())
        app.currentPhotoPort = history
        super.init()
        setupViewControllerDependencies()
    }

    private func setupViewControllerDependencies() {
        controllerDependencies["TopPlaces"] =  { [unowned self] in
            let vc = $0 as TopPlacesTableViewController
            vc.dataSource = self.topPlacesViewModel
            vc.splitViewController?.preferredDisplayMode = .AllVisible
        }

        controllerDependencies["Photos"] =  { [unowned self] in
            let vc = $0 as PhotosViewController
            vc.dataSource = PhotosViewModel(app: self.app, useCaseFactory: self.useCaseFactory)
            vc.imageController = self.makeImageViewControllerWithStoryBoard(vc.storyboard!)
        }

        controllerDependencies["Image"] =  { [unowned self] in
            let vc = $0 as ImageViewController
            vc.useCaseFactory = self.useCaseFactory
        }

        let splitSetup: UIViewControllerInjector = { [unowned self] in
            let vc = $0 as UISplitViewController
            vc.delegate = self.splitControllerDelegate
        }
        controllerDependencies["Split"] = {
            let vc = $0 as UISplitViewController
            vc.tabBarItem.selectedImage = UIImage(named: "bar_photo_selected")
            splitSetup(vc)
        }
        controllerDependencies["SplitHistory"] = splitSetup

        controllerDependencies["History"] = { [unowned self] in
            let vc = $0 as HistoryTableViewController
            vc.dataSource = SelectedPhotosHistoryViewModel(app: self.app, history: self.history)
            vc.splitViewController?.preferredDisplayMode = .AllVisible
            vc.imageController = self.makeImageViewControllerWithStoryBoard(vc.storyboard!)
        }
    }

    private func makeImageViewControllerWithStoryBoard(storyboard: UIStoryboard) -> ImageViewController {
        return storyboard.instantiateViewControllerWithIdentifier("Image") as ImageViewController
    }
}
