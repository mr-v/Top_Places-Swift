//
//  FlickrPhotosViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FlickrPhotosViewModel: NSObject, UITableViewDataSource {
    let reuseId = "PhotoCell"
    let app: FlickrApp
    var placeId:String!

    init(app: FlickrApp) {
        self.app = app
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
        // workaround - empty strings detail label would set size to 0 and wouldn't update when reused, resulting in non-visible detail
        cell.detailTextLabel!.text = photo.description.isEmpty ? " " : photo.description
        return cell
    }
}
