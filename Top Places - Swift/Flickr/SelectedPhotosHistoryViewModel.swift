//
//  SelectedPhotosHistoryViewModel.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 06/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class SelectedPhotosHistoryViewModel: NSObject, UITableViewDataSource {
    let reuseIdentifier = "HistoryCell"
    let noItemsTitle = "No picked photo history"
    lazy var noItemsDescription: String = { "This tab displays last \(self.history.picksLimit) picked photos from Photos" }()
    let history: SelectedPhotosHistory
    let app: FlickrApp

    init(app: FlickrApp, history: SelectedPhotosHistory) {
        self.app = app
        self.history = history
    }

    func loadHistory() {
        history.loadHistory()
    }

    func didSelectPhotoAtIndexPath(indexPath: NSIndexPath) {
        let photo = photoForIndexPath(indexPath)
        app.updateCurrentPhoto(photo)
    }

    func photoForIndexPath(indexPath: NSIndexPath) -> Photo {
        return history.lastPickedPhotos[indexPath.row]
    }

    // MARK: - Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(history.lastPickedPhotos.count, 1)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        func textsForLabels() -> (title: String, description: String) {
            if !history.lastPickedPhotos.isEmpty {
                let photo = photoForIndexPath(indexPath)
                let photoDescription = !photo.description.isEmpty ? photo.description : " " // othwerwise subtitles would dissapear during scrolling
                return (photo.title, photoDescription)
            } else {
                return (noItemsTitle, noItemsDescription)
            }
        }

        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        let texts = textsForLabels()
        cell.textLabel.text = texts.title
        cell.detailTextLabel?.text = texts.description
        cell.userInteractionEnabled = !history.lastPickedPhotos.isEmpty
        return cell
    }
}
