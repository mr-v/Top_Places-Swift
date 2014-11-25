//
//  ImageViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, FlickrAppPickedPhotoURLPort {
    @IBOutlet weak var scrollView: ImageScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    var flickrService: FlickrService!
    var imageService: FlickrImageService!

    var photo: Photo? {
        didSet {
            title = photo!.title
            flickrService.fetchSizesForPhotoId(photo!.photoId, callback: didUpdatePickedPhotoURL)
            showLoadingUI()
        }
    }

    // TODO: add error handling: couldn't load the image/network problems

    override func viewDidLoad() {
        let hasSelectedPhoto = photo? != nil
        if isLoadingPhoto() {
            showLoadingUI()
        }

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }


    private func isLoadingPhoto() -> Bool {
        let hasSelectedPhoto = photo? != nil
        return hasSelectedPhoto && scrollView.imageView.image == nil
    }

    func showLoadingUI() {
        scrollView?.imageView.image = nil
        activityIndicator?.startAnimating()
        errorLabel?.hidden = true
    }

    func didUpdatePickedPhotoURL(url: NSURL) {
        imageService.fetchImage(self, url: url) {
            image in
            self.scrollView.zoomScale = 1
            self.scrollView.imageView.image = image
            let scaleX = self.view.frame.height/image.size.height
            let scaleY = self.view.frame.width/image.size.width
            let ratio = min(min(scaleX, scaleY), 1)
            self.scrollView.minimumZoomScale = ratio * 0.5
            self.scrollView.maximumZoomScale = max(ratio * 3, 1)
            self.scrollView.zoomScale = ratio
            self.scrollView.defaultZoomScale = ratio
            self.activityIndicator.stopAnimating()
            self.navigationController?.hidesBarsOnTap = true
        }
    }

    deinit {
        navigationController?.hidesBarsOnTap = false
    }
}
