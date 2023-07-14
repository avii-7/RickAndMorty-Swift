//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach for location
final class RMLocationViewController: UIViewController {
    
    private let locationListView = RMLocationListView()
    
    private let viewModel = RMLocationViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Locations"
        view.addSubview(locationListView)
        addConstraints()
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(serachType: .Location)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
