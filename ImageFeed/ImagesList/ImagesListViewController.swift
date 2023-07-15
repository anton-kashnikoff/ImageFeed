//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 07.05.2023.
//

import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var imagesListService: ImagesListService?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - UIViewController
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController, let indexPath = sender as? IndexPath, let imagesListService else {
                return
            }
            
            viewController.imageObject = imagesListService.photos[indexPath.row]
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesListService = ImagesListService()
        imagesListService?.fetchPhotosNextPage()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateTableViewAnimated()
        })
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: - Public methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        guard let photo = imagesListService?.photos[indexPath.row] else {
            return
        }
        cell.setupGradient(for: photo)
        
        cell.cellImage.kf.setImage(with: URL(string: photo.thumbImageURL)) { result in
            switch result {
            case .success(_):
                cell.gradient.removeFromSuperlayer()
            case .failure(let error):
                print(error.localizedDescription)
                cell.cellImage.image = UIImage(named: "stub")
            }
        }
        
        cell.dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())

        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            guard let photosCount = imagesListService?.photos.count else {
                return
            }
            
            for row in photosCount - 10...photosCount - 1 {
                tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        imagesListService?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = imagesListService?.photos[indexPath.row] else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom

        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imagesListService else {
            return
        }
        
        if indexPath.row == imagesListService.photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
//
//        if let cell = cell as? ImagesListCell {
//            let photo = imagesListService.photos[indexPath.row]
//            cell.setupGradient(for: photo)
//        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell), let photo = imagesListService?.photos[indexPath.row] else {
            return
        }
        
        UIBlockingProgressHUD.show()
        imagesListService?.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success(_):
                let likeImage = photo.isLiked ? UIImage(named: "like_button_off") : UIImage(named: "like_button_on")
                cell.likeButton.setImage(likeImage, for: .normal)
                UIBlockingProgressHUD.dismiss()
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Что-то пошло не так.", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alertController, animated: true)
            }
        }
    }
}
