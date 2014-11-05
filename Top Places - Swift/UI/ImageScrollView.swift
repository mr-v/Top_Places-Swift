//
//  ImageScrollView.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    lazy var imageView: UIImageView = {
        var view = UIImageView()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(view)
        self.delegate = self
        return view
    }()
    override var delegate: UIScrollViewDelegate? {
        set {
            if newValue !== self && newValue != nil {
                fatalError("can't set a custom delegate for \(NSStringFromClass(ImageScrollView.self))")
            }
            super.delegate = newValue
        }
        get {
            return super.delegate
        }
    }
    var defaultZoomScale: CGFloat = 1

    override func layoutSubviews() {
        super.layoutSubviews()

        // center image
        var contentsFrame = imageView.frame
        var origin = CGPointZero

        if (contentsFrame.width < bounds.width) {
            origin.x = round((bounds.width - contentsFrame.width)/2)
        }

        if (contentsFrame.height < bounds.height) {
            origin.y = round((bounds.height - contentsFrame.height)/2)
        }

        imageView.frame.origin = origin;
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView {
        return imageView
    }

    // fixes view adjustments at the end of the zoom that weirdly offset animation
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) {
        bounces = false
    }

    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
        bounces = zoomScale > defaultZoomScale
    }

    func scrollViewDidZoom(scrollView: UIScrollView) {
        layoutSubviews()
    }
}
