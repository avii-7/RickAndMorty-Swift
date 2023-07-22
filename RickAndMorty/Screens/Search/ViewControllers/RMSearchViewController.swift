//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Arun on 08/07/23.
//

import UIKit

final class RMSearchViewController: UIViewController {
    
    private let searchType: RMSearchType
    
    private let searchView: RMSearchView
    
    init(for moduleType : RMModuleType) {
        searchType = RMSearchType(moduleType: moduleType)
        let viewModel = RMSearchViewViewModel(searchType)
        searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        title = searchType.displayTitle
        view.addSubview(searchView)
        addConstraints()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]) 
    }
}
