//
//  ImageViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, FlickrAppPickedPhotoURLPort, FlickrAppCurrentPhotoPort {
    @IBOutlet weak var scrollView: ImageScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noSelectionLabel: UILabel!

    var flickrService: FlickrService!
    var photo: FlickrPhoto! {
        didSet {
            title = photo.title
            scrollView?.imageView.image = nil
            flickrService.fetchSizesForPhotoId(photo.photoId)
            activityIndicator?.startAnimating()
        }
    }
    var imageService: FlickrImageService!

    override func viewDidLoad() {
        let hasPhotoToLoad = photo? != nil
        noSelectionLabel.hidden = hasPhotoToLoad
        let isLoadingPhoto = hasPhotoToLoad && scrollView.imageView.image == nil
        isLoadingPhoto ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }

    func didUpdatePickedPhotoURL(url: NSURL) {
        imageService.fetchImage(url) {
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
