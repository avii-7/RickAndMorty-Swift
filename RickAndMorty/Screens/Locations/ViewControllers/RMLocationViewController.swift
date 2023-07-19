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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
        view.backgroundColor = .systemBackground
        title = "Locations"
        view.addSubview(locationListView)
        locationListView.selectionDelegate = self
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

extension RMLocationViewController: SelectionDelegate {
    
    func didSelect<T>(with model: T) {
        guard let model: RMLocation = model as? RMLocation else { return }
        let vc = RMLocationDetailViewController(model: model)
        navigationController?.pushViewController(vc, animated: true)
    }
}
