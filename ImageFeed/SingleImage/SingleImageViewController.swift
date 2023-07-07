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
    
    // MARK: - Private Properties
    private var image: UIImage?
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImage()
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
    
    // MARK: - Private Methods
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: URL(string: imageObject?.largeImageURL ?? "")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {
                return
            }
            
            switch result {
            case .success(let imageResult):
                self.imageView.frame.size = imageResult.image.size
                self.image = imageResult.image
                self.updateMinZoomScale(for: imageResult.image.size)
            case .failure(_):
                let alertController = UIAlertController(title: "Что-то пошло не так.", message: "Попробовать ещё раз?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Нет", style: .cancel))
                alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
                    self?.setImage()
                })
                present(alertController, animated: true)
            }
        }
    }
    
    private func updateMinZoomScale(for size: CGSize) {
        let widthScale = scrollView.bounds.size.width / size.width
        let heightScale = scrollView.bounds.size.height / size.height
        let minScale = min(widthScale, heightScale)

        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let yOffset = max(0, (scrollView.bounds.size.height - imageView.frame.size.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset

        let xOffset = max(0, (scrollView.bounds.size.width - imageView.frame.size.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset

        view.layoutIfNeeded()
    }
}
