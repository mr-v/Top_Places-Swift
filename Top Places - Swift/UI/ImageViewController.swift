//
//  ImageViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, FlickrAppPickedPhotoURLPort, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: ImageScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var flickrService: FlickrService!
    var photo: FlickrPhoto! {
        didSet {
            flickrService.fetchSizesForPhotoId(photo.photoId)
            activityIndicator?.startAnimating()
        }
    }
    var imageService: FlickrImageService!

    func didUpdatePickedPhotoURL(url: NSURL) {
        imageService.fetchImage(url) {
            image in
            self.scrollView.imageView.image = image
            let scaleX = self.view.frame.height/image.size.height
            let scaleY = self.view.frame.width/image.size.width
            let ratio = min(min(scaleX, scaleY), 1)
            self.scrollView.minimumZoomScale = ratio * 0.5
            self.scrollView.maximumZoomScale = ratio * 3
            self.scrollView.zoomScale = ratio
            self.scrollView.defaultZoomScale = ratio
            self.activityIndicator.stopAnimating()
        }
    }
}
