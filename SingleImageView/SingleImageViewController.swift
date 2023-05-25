//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 18.05.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var image: UIImage! {
        didSet {
            guard isViewLoaded else {
                return
            }
            imageView.image = image
//            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
//    private func rescaleAndCenterImageInScrollView(image: UIImage) {
//        view.layoutIfNeeded()
//        
//        let visibleRectSize = scrollView.bounds.size
//        let hScale = visibleRectSize.width / image.size.width
//        let vScale = visibleRectSize.height / image.size.height
//        let scale = min(scrollView.maximumZoomScale, max(scrollView.minimumZoomScale, max(hScale, vScale)))
//        
//        scrollView.setZoomScale(scale, animated: false)
//        scrollView.layoutIfNeeded()
//        
//        let newContentSize = scrollView.contentSize
//        let x = (newContentSize.width - visibleRectSize.width) / 2
//        let y = (newContentSize.height - visibleRectSize.height) / 2
//        
//        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
//    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        
//        scrollView.minimumZoomScale = 0.1
//        scrollView.maximumZoomScale = 1.25
        
//        rescaleAndCenterImageInScrollView(image: image)
    }
    
    // MARK: - IBAction
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton() {
        guard let image else {
            print("No image found")
            return
        }
        
        let shareVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(shareVC, animated: true)
    }
    
    func updateMinZoomScale() {
        let widthScale = view.bounds.size.width / imageView.bounds.width
        let heightScale = view.bounds.size.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
}

    // MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinZoomScale()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }

    func updateConstraints() {
        let yOffset = max(0, (view.bounds.size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (view.bounds.size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}
