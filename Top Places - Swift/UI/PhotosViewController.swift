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
        performSegueWithIdentifier("ShowImage", sender: self)
        // this way image loading is decoupled from view controller hierarchy changes (embedding in navigation controller, split controller, etc.)
        dataSource.didSelectPhotoAtIndexPath(indexPath)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowImage" {
            let controller = (segue.destinationViewController as UINavigationController).topViewController
            controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
}
