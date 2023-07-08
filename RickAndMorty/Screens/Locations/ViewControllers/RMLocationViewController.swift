//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach for location
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Locations"
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(serachType: .Location)
        navigationController?.pushViewController(vc, animated: true)
    }
}
