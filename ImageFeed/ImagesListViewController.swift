//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by Антон Кашников on 07.05.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
