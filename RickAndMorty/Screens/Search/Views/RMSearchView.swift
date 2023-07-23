//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

class RMSearchView: UIView {

    private let viewModel: RMSearchViewViewModel
    
    private let noSearchResultView = RMNoSearchResultView()
    
    private let searchInputView = RMSearchInputView()
    
    public weak var delegate: RMSelectionDelegate?
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(noSearchResultView, searchInputView)
        addconstraints()
        searchInputView.config(viewModel: .init(type: viewModel.searchType.moduleType))
        searchInputView.delegate = self
        viewModel.registerOptionChangeBlock {[weak self] (option, value) in
            self?.searchInputView.update(option: option, value: value)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func addconstraints() {
        NSLayoutConstraint.activate([
            // Input search view.
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // No results view.
            noSearchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noSearchResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noSearchResultView.topAnchor.constraint(equalTo: topAnchor),
            noSearchResultView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

extension RMSearchView: RMSelectionDelegate {
    
    func didSelect<T>(with model: T) {
        delegate?.didSelect(with: model)
    }
}
