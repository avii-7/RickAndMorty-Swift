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
    
    private let viewModel: RMSearchViewViewModel
    
    init(for moduleType : RMModuleType) {
        searchType = RMSearchType(moduleType: moduleType)
        self.viewModel = RMSearchViewViewModel(searchType)
        searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        searchView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = .init(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch)
        )
        view.backgroundColor = .systemBackground
        title = searchType.displayTitle
        view.addSubview(searchView)
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    @objc private func didTapExecuteSearch() {
        viewModel.executeSearch()
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

extension RMSearchViewController: RMSelectionDelegate {
    func didSelect<T>(with model: T) {
        guard let option = model as? RMDynamicOption else { return }
        
        let vc = RMSearchOptionPickerViewController(with: option) { [weak self] selection in
            self?.viewModel.set(value: selection, for: option)
        }
        vc.sheetPresentationController?.detents = .init(arrayLiteral: .medium())
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }
}
