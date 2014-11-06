//
//  HistoryTableViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var dataSource: FlickrSelectedPhotosHistoryViewModel!
    var flickrService: FlickrService!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Recent Picks"
        tableView.dataSource = dataSource        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadHistory()
    }

    private func loadHistory() {
        dataSource.loadHistory()
        tableView.reloadData()
    }

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
