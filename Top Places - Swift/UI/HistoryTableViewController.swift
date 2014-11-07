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
    var imageController: UIViewController!

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
        showDetailViewController(imageController, sender: self)
        dataSource.didSelectPhotoAtIndexPath(indexPath)
        tableView.reloadData()
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: .None)
    }
}
