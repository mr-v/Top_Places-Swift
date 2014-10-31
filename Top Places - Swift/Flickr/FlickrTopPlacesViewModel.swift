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

    // MARK: - Data Source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let country = countryForSection(section)
        let sectionPlaces = app.topPlaces[country]!
        return sectionPlaces.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as UITableViewCell
        let country = countryForSection(indexPath.section)
        let place = app.topPlaces[country]![indexPath.row]
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
        sectionToName = countries.reduce([]) {
            (var mapping, country) in
            mapping.append(country)
            return mapping
        }
    }

    private func countryForSection(section: Int) -> String {
        return sectionToName[section]
    }
}
