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
    override var bounds: CGRect {
        didSet {
            // catch rotation and split controller collapsing
            if oldValue.size != bounds.size {
                centerImageForSize(bounds.size)
            }
        }
    }
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
        centerImageForSize(bounds.size)
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
        centerImageForSize(bounds.size)
    }

    private func centerImageForSize(size: CGSize) {
        var contentsFrame = imageView.frame
        var origin = imageView.frame.origin

        if contentsFrame.width < size.width {
            origin.x = round((size.width - contentsFrame.width)/2)
        } else if origin.x > 0 {
            // moves image to edge when split view controller is collapsed and new bounds are smaller than zoomed image
            origin.x = 0
        }

        if contentsFrame.height < size.height {
            origin.y = round((size.height - contentsFrame.height)/2)
        } else if origin.y > 0 {
            origin.y = 0
        }

        imageView.frame.origin = origin;
    }

}
