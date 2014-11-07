//
//  FlickrTopPlacesViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 30/10/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class FlickrTopPlacesViewModel: NSObject, UITableViewDataSource, FlickrAppTopPlacesPort {
    let reuseId = "PlaceCell"
    let app: FlickrApp
    var sectionToName: [String]!

    init(app: FlickrApp) {
        self.app = app
    }

    func didUpdateTopPlaces() {
        updateSectionToName()
    }

    func placeForIndexPath(indexPath: NSIndexPath) -> FlickrPlace {
        let country = countryForSection(indexPath.section)
        return app.topPlaces[country]![indexPath.row]
    }

    // MARK: - Data Source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let country = countryForSection(section)
        let sectionPlaces = app.topPlaces[country]!
        return sectionPlaces.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as UITableViewCell
        let place = placeForIndexPath(indexPath)
        cell.textLabel.text = place.name
        cell.detailTextLabel!.text = place.description
        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return app.topPlaces.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return countryForSection(section)
    }

    // MARK: - 

    private func updateSectionToName() {
        var countries = app.topPlaces.keys.array
        countries.sort(<)
        sectionToName = countries
    }

    private func countryForSection(section: Int) -> String {
        return sectionToName[section]
    }
}
