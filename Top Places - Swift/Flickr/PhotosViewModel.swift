//
//  PhotosViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PhotosViewModel: NSObject, UITableViewDataSource {
    private let reuseId = "PhotoCell"
    private let app: FlickrApp
    var placeId:String!
    private let useCaseFactory: IUseCaseFactory
    weak var delegate: DataSourceDelegate!

    init(app: FlickrApp, useCaseFactory: IUseCaseFactory) {
        self.app = app
        self.useCaseFactory = useCaseFactory
    }

    func updatePhotos() {
        let parameters: UseCaseFactoryParameters = [CompletionHandlerUseCaseKey: onPhotosUpdateCompletion,
            PlaceIdUseCaseKey: placeId]
        let updateTopPlaces = useCaseFactory.createWithType(.UpdatePhotosForPlace, parameters: parameters)
        updateTopPlaces.execute()
    }

    private func onPhotosUpdateCompletion(result: Result<(String, [Photo])>) {
        switch result {
        case .OK(let (id, photos)):
            app.photos[id] = photos
        case .Error:
            false   // TODO: add logging?
        }
        delegate?.dataSourceDidChangeContent()
    }

    func didSelectPhotoAtIndexPath(indexPath: NSIndexPath) {
        let photo = photoForIndexPath(indexPath)
        app.updateCurrentPhoto(photo)
    }

    func photoForIndexPath(indexPath: NSIndexPath) -> Photo {
        return app.photos[placeId]![indexPath.row]
    }

    // MARK: - Data Source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return app.photos[placeId]?.count ?? 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as UITableViewCell
        let photo = app.photos[placeId]![indexPath.row]
        cell.textLabel.text = photo.title
        // workaround - empty strings detail label would have set size to 0 and wouldn't update when reused, resulting in non-visible detail
        cell.detailTextLabel!.text = photo.description.isEmpty ? " " : photo.description
        return cell
    }
}
