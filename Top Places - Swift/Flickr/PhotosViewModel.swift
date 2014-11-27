//
//  PhotosViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PhotosViewModel: NSObject, UITableViewDataSource {
    var placeId:String!
    weak var delegate: DataSourceDelegate!
    private let reuseId = "PhotoCell"
    private let app: FlickrApp
    private let useCaseFactory: IUseCaseFactory
    private var loadingUseCase: UseCase?

    init(app: FlickrApp, useCaseFactory: IUseCaseFactory) {
        self.app = app
        self.useCaseFactory = useCaseFactory
    }

    func updatePhotos() {
        let parameters = UseCaseFactoryParametersComponents().placeId(placeId).completionHandler(makePhotosUpdateHandler()).parameters
        loadingUseCase?.cancel()
        loadingUseCase = useCaseFactory.createWithType(.UpdatePhotosForPlace, parameters: parameters)
        loadingUseCase!.execute()
    }

    private func makePhotosUpdateHandler() -> (Result<(String, [Photo])>) -> () {
        return { [weak self] result in
            switch result {
            case .OK(let (id, photos)):
                self?.app.photos[id] = photos
            case .Error:
                false
            }
            self?.delegate?.dataSourceDidChangeContent()
            self?.loadingUseCase = nil
        }
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
        cell.textLabel!.text = photo.title
        // workaround - empty strings detail label would have set size to 0 and wouldn't update when reused, resulting in non-visible detail
        cell.detailTextLabel!.text = photo.description.isEmpty ? " " : photo.description
        return cell
    }

    deinit {
        loadingUseCase?.cancel()
        loadingUseCase = nil
    }
}
