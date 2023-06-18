//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(didSelectCharacter character: RMCharacter)
}

/// Custom view that showing list of characters, loader, infinite loading etc
final class RMCharacterListView: UIView {
    
    private let viewModel = RMCharacterListViewModel()
    
    public weak var delegate: RMCharacterListViewDelegate?
    
    // Block pattern
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(
            RMLoadingFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "RMLoadingFooterCollectionResuableView"
        )
        return collectionView
    }()
    
    // MARK: - Int
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchInitialCharacters()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) { 
        fatalError("Unsupported constructor")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMCharacterListView: RMCharacterListViewModelDelegate {
    func didLoadMoreCharacters(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
    
    
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(didSelectCharacter: character)
    }
    
    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
