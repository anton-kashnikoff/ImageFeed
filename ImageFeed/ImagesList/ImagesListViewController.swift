//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 07.05.2023.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var imagesListPresenter: ImagesListPresenterProtocol? { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }
    func showErrorAlert()
}

class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    // MARK: - IBOutlet
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Private Properties
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    
    // MARK: - Public Properties
    var imagesListPresenter: ImagesListPresenterProtocol?
    var imagesListService: ImagesListServiceProtocol?
    
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
        imagesListService = ImagesListService.shared
        imagesListPresenter = ImagesListPresenter()
        imagesListPresenter?.imagesListService = ImagesListService.shared
        imagesListPresenter?.imagesListHelper = ImagesListHelper()
        print("I'm here")
        imagesListPresenter?.viewDidLoad()
        
        imagesListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.updateTableViewAnimated()
        })
        print("finish vdl")
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    // MARK: - Public methods
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        guard let photo = imagesListService?.photos[indexPath.row] else {
            return
        }
        
        imagesListPresenter?.configCell(cell, photo: photo)
    }
    
    func updateTableViewAnimated() {
        print("updateTVAnimated")
        tableView.performBatchUpdates {
            guard let photosCount = imagesListService?.photos.count else {
                return
            }
            
            for row in photosCount - 10...photosCount - 1 {
                tableView.insertRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
            }
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Что-то пошло не так.", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alertController, animated: true)
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
        guard let photo = imagesListService?.photos[indexPath.row], let imagesListPresenter else {
            return 0
        }

        return imagesListPresenter.heightForRow(with: photo, tableViewWidth: tableView.bounds.width)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let imagesListService else {
            print("А нет презентера")
            return
        }
        print("Всё норм")
        if indexPath.row == imagesListService.photos.count - 1 {
            print("Я в ifе")
            imagesListService.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell), let photo = imagesListService?.photos[indexPath.row] else {
            return
        }
        
        imagesListPresenter?.changeLike(for: cell, photo: photo)
    }
}
