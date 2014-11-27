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
    @IBOutlet weak var messageLabel: UILabel!

    var useCaseFactory: IUseCaseFactory!
    private var loadingUseCase: UseCase?
    var photo: Photo? {
        didSet {
            title = photo!.title

            loadingUseCase?.cancel()
            let parameters = UseCaseFactoryParametersComponents().photoId(photo!.photoId).completionHandler(didLoadImage).parameters
            loadingUseCase = useCaseFactory.createWithType(.LoadPhotoWithId, parameters: parameters)
            loadingUseCase!.execute()
            showLoadingUI()
        }
    }

    override func viewDidLoad() {
        if isLoadingPhoto() {
            showLoadingUI()
        }

        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if let isMoving = navigationController?.isMovingFromParentViewController() {
            if isMoving {
                loadingUseCase?.cancel()
                loadingUseCase = nil
            }
        }
    }

    private func isLoadingPhoto() -> Bool {
        return loadingUseCase != nil
    }

    func showLoadingUI() {
        scrollView?.imageView.image = nil
        activityIndicator?.startAnimating()
        messageLabel?.hidden = true
    }

    func didLoadImage(result: Result<UIImage>) {
        activityIndicator?.stopAnimating()
        switch result {
        case .OK(let image):
            messageLabel.hidden = true
            setImage(image)
        case .Error:
            messageLabel.hidden = false
            messageLabel.text = "Couldn't load image"
        }
        loadingUseCase = nil
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
