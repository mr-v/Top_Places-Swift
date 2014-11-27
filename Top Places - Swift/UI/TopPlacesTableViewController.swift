//
//  CountriesTableViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class TopPlacesTableViewController: UITableViewController, DataSourceDelegate {
    var dataSource: TopPlacesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Top Places"
        dataSource.delegate = self
        tableView.dataSource = dataSource
        fetchTopPlaces()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func fetchTopPlaces() {
        refreshControl?.beginRefreshing()
        dataSource.updateTopPlaces()
    }

    func dataSourceDidChangeContent() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    // MARK: - Table View delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowPlacePhotoList", sender: self)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let photosViewController = segue.destinationViewController as? PhotosViewController {
            photosViewController.place = dataSource.placeForIndexPath(tableView.indexPathForSelectedRow()!)
        }
    }
}