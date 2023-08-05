//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

final class RMSearchView: UIView {

    private let viewModel: RMSearchViewViewModel
    
    private let noSearchResultView = RMNoSearchResultView()
    
    private let searchInputView = RMSearchInputView()
    
    private let searchResultView = RMSearchResultsView()
    
    public weak var delegate: RMSelectionDelegate?
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(searchInputView, noSearchResultView, searchResultView)
        addconstraints()
        searchInputView.config(viewModel: .init(type: viewModel.searchType.moduleType))
        searchInputView.delegate = self
        searchInputView.searchBarDelegate = self
        registerCompletionHandlers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func registerCompletionHandlers() {
        
        viewModel.registerOptionChangeBlock {[weak self] (option, value) in
            self?.searchInputView.update(option: option, value: value)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.noSearchResultView.isHidden  = true
                self?.searchResultView.isHidden = false
                self?.searchResultView.configure(with: results)
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noSearchResultView.isHidden  = false
                self?.searchResultView.isHidden = true
            }
        }
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
            noSearchResultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: 10),
            noSearchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Search result view.
            searchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchResultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor, constant: 10),
            searchResultView.bottomAnchor.constraint(equalTo: bottomAnchor),
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

extension RMSearchView: RMSearchBarDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputView_DidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}
