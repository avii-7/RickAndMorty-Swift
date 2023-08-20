//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

final class RMSearchView: UIView {
    
    private let viewModel: RMSearchViewViewModel

    private let searchInputView = RMSearchInputView()
    
    private let noSearchResultView = RMNoSearchResultView()
    
    private let searchResultView = RMSearchResultsView()
    
    private var queryText: String = String.empty
    
    // For centering activity indicator between serach input view and bottom anchor of view.
    private var opaqueBox: UILayoutGuide = {
        let opaqueBox = UILayoutGuide()
        return opaqueBox
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
     weak var delegate: RMSelectionDelegate?
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addLayoutGuide(opaqueBox)
        addSubviews(searchInputView, noSearchResultView, searchResultView, spinner)
        addconstraints()
        searchInputView.config(viewModel: .init(type: viewModel.searchType.moduleType))
        searchInputView.delegate = self
        searchInputView.searchBarDelegate = self
        searchResultView.delegate = self
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
                self?.spinner.stopAnimating()
                self?.noSearchResultView.isHidden  = true
                self?.searchResultView.isHidden = false
                self?.searchResultView.configure(with: results)
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.noSearchResultView.isHidden  = false
                self?.searchResultView.isHidden = true
            }
        }
    }
    
    func addconstraints() {
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
            
            // Opaque box
            opaqueBox.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            opaqueBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            opaqueBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            opaqueBox.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Activity indicator
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: opaqueBox.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: opaqueBox.centerYAnchor)
        ])
    }
    
    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
    
    func startSearching() {
        
        if queryText.isEmpty {
            return
        }
        
        searchResultView.isHidden = true
        noSearchResultView.isHidden = true
        spinner.isHidden = false
        spinner.startAnimating()
        viewModel.executeSearch()
    }
}

extension RMSearchView: RMSelectionDelegate {
    
    func didSelect<T>(with model: T) {
        if let indexPath = model as? IndexPath {
            switch viewModel.searchType.moduleType {
            case .Location:
                guard let location = viewModel.getlocation(at: indexPath) else { return }
                delegate?.didSelect(with: location)
            case .Character:
                guard let character = viewModel.getCharacter(at: indexPath) else { return }
                delegate?.didSelect(with: character)
            case .Episode:
                guard let episode = viewModel.getEpisode(at: indexPath) else { return }
                delegate?.didSelect(with: episode)
            }   
        }
        else {
            delegate?.didSelect(with: model)
        }
    }
}

extension RMSearchView: RMSearchBarDelegate {
    func rmSearchInputView_DidTapCrossButton(_ inputView: RMSearchInputView) {
        searchResultView.isHidden = true
        noSearchResultView.isHidden = false
        if spinner.isAnimating {
            spinner.stopAnimating()
        }
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        queryText = text
        viewModel.set(query: text)
    }
    
    func rmSearchInputView_DidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        startSearching()
    }
}

