//
//  PhotosViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class PhotosViewController: UITableViewController, DataSourceDelegate {
    var dataSource: PhotosViewModel!
    var imageController: ImageViewController!
    var place: Place! {
        didSet {
            title = place.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource.delegate = self
        dataSource.placeId = place.placeId
        tableView.dataSource = dataSource
        fetchPhotosFromPlace()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if isMovingFromParentViewController() {
            dataSource = nil
        }
    }

    @IBAction func fetchPhotosFromPlace() {
        refreshControl?.beginRefreshing()
        dataSource.updatePhotos()
    }

    func dataSourceDidChangeContent() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        imageController.photo = dataSource.photoForIndexPath(indexPath)
        showDetailViewController(UINavigationController(rootViewController: imageController), sender: self)
        dataSource.didSelectPhotoAtIndexPath(indexPath)
    }
}
