//
//  ImageViewController.swift
//  Top Places - Swift
//
//  Created by Witold Skibniewski on 04/11/14.
//  Copyright (c) 2014 Witold Skibniewski. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var scrollView: ImageScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!

    var useCaseFactory: IUseCaseFactory!
    var photo: Photo? {
        didSet {
            title = photo!.title

            let parameters = UseCaseFactoryParametersComponents().photoId(photo!.photoId).completionHandler(didLoadImage).parameters
            let useCase = useCaseFactory.createWithType(.LoadPhotoWithId, parameters: parameters)
            useCase.execute()
            showLoadingUI()
        }
    }

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

    func didLoadImage(result: Result<UIImage>) {
        activityIndicator?.stopAnimating()
        switch result {
        case .OK(let image):
            errorLabel.hidden = true
            setImage(image)
        case .Error:
            errorLabel.hidden = false
            errorLabel.text = "Couldn't load image"
        }
    }

    private func setImage(image: UIImage) {
        scrollView.zoomScale = 1
        scrollView.imageView.image = image
        let scaleX = self.view.frame.height/image.size.height
        let scaleY = self.view.frame.width/image.size.width
        let ratio = min(min(scaleX, scaleY), 1)
        scrollView.minimumZoomScale = ratio * 0.5
        scrollView.maximumZoomScale = max(ratio * 3, 1)
        scrollView.zoomScale = ratio
        scrollView.defaultZoomScale = ratio
        navigationController?.hidesBarsOnTap = true
    }

    deinit {
        navigationController?.hidesBarsOnTap = false
    }
}
