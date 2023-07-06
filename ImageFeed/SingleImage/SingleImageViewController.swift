//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 18.05.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Public Properties
    var imageObject: Photo?
    
    var image: UIImage! // {
//        didSet {
//            guard isViewLoaded else {
//                return
//            }
//            imageView.kf.setImage(with: URL(string: imageObject?.largeImageURL ?? ""))
//        }
//    }
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: imageObject?.largeImageURL ?? "")) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let imageResult):
                print("success")
                print("Result Image width: \(imageResult.image.size.width)")
                print("Result Image height: \(imageResult.image.size.height)")
                self.imageView.frame.size = imageResult.image.size
                self.image = imageResult.image
                self.updateMinZoomScale(for: imageResult.image.size)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
    func updateMinZoomScale(for size: CGSize) {
        print(scrollView.bounds.size.width)
        print(size.width)
        
        print(scrollView.bounds.size.height)
        print(size.height)
        
        let widthScale = scrollView.bounds.size.width / size.width
        let heightScale = scrollView.bounds.size.height / size.height
        let minScale = min(widthScale, heightScale)
        
        print("widthScale = \(widthScale)")
        print("heightScale = \(heightScale)")
        print("minScale = \(minScale)")

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        updateMinZoomScale()
//    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("Image width: \(imageView.frame.size.width)")
        print("Image height: \(imageView.frame.size.height)")
        let yOffset = max(0, (scrollView.bounds.size.height - imageView.frame.size.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (scrollView.bounds.size.width - imageView.frame.size.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}
