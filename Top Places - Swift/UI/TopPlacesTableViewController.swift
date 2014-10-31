//
//  CountriesTableViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class TopPlacesTableViewController: UITableViewController, FlickrAppPort {
    var dataSource: FlickrTopPlacesViewModel!
    var flickrService: FlickrService!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        fetchTopPlaces()
    }

    @IBAction func fetchTopPlaces() {
        refreshControl?.beginRefreshing()
        flickrService.fetchTopPlaces()
    }

    func topPlacesUpdated() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
}