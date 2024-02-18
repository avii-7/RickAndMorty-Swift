//
//  LocationViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach for location
final class RMLocationViewController: UIViewController {
    
    private let locationListView: RMLocationListView
    
    init() {
        let viewModel = RMLocationViewViewModel(listSource: RemoteDataSource())
        locationListView = RMLocationListView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        setRightBarButton()

        locationListView.delegate = self
        locationListView.loadInitialLocations()
        view.addSubview(locationListView)
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
