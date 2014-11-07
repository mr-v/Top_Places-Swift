//
//  PhotosViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PhotosViewController: UITableViewController, FlickrAppPlacePhotosPort {
    var place: FlickrPlace! {
        didSet {
            title = place.name
        }
    }
    var dataSource: FlickrPhotosViewModel!
    var flickrService: FlickrService!
    var imageController: UIViewController!

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

    func didUpdatePhotosForPlace(placeId: String) {
        if place.placeId == placeId {
            tableView.reloadData()
            refreshControl?.endRefreshing()
        }
    }

    // TODO: handle errror case... - refreshControl, text?

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showDetailViewController(imageController, sender: self)
        dataSource.didSelectPhotoAtIndexPath(indexPath)
    }
}
