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
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        setRightBarButton()
        
        view.addSubview(locationListView)
        locationListView.delegate = self
        
        let listSource = RemoteDataSource()
        let viewModel = RMLocationViewViewModel(listSource: listSource)
        locationListView.viewModel = viewModel
        
        locationListView.loadInitialLocations()
        addConstraints()
    }
    
    
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            locationListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(for: .Location)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMLocationViewController: RMLocationListViewDelegate {
    
    func rmLocationListView(didSelectLocation location: RMLocation) {
        let viewModel = RMLocationDetailViewViewModel(location: location)
        let vc = RMLocationDetailViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
