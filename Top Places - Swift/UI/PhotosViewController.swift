//
//  PhotosViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PhotosViewController: UITableViewController, FlickrAppPlacePhotosPort {
    var dataSource: FlickrPhotosViewModel!
    var imageController: ImageViewController!
    var flickrService: FlickrService!
    var place: FlickrPlace! {
        didSet {
            title = place.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.placeId = place.placeId
        tableView.dataSource = dataSource
        fetchPhotosFromPlace()
    }

    @IBAction func fetchPhotosFromPlace() {
        flickrService.fetchPhotosFromPlace(place.placeId)
        refreshControl?.beginRefreshing()
    }

    // TODO: handle errror case... - refreshControl, feedback; add callbacks for success/failure?
    func didUpdatePhotosForPlace(placeId: String) {
        if place.placeId == placeId {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        imageController.photo = dataSource.photoForIndexPath(indexPath)
        showDetailViewController(UINavigationController(rootViewController: imageController), sender: self)
        dataSource.didSelectPhotoAtIndexPath(indexPath)
    }
}
