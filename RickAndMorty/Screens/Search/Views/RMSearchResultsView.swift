//
//  SearchResultsView.swift
//  RickAndMorty
//
//  Created by Arun on 28/07/23.
//

import UIKit

protocol RMSearchResultViewViewModelDelegate: AnyObject {
    func didLoadLocations()
    func didLoadCharactersOrEpisodes()
    
    func didSelectLocation(with model: RMLocation)
    func didSelectCharacter(with model: RMCharacter)
    func didSelectEpisode(with model: RMEpisode)
    
    func didLoadMoreLocations(at indexPaths: [IndexPath])
    func didLoadMoreCharactersOrEpisodes(at indexPaths: [IndexPath])
}

final class RMSearchResultsView: UIView {
    
    private var viewModel = RMSearchResultViewViewModel()
    
    weak var delegate: RMSelectionDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        tableView.register(
            RMLoadingFooterTableView.self,
            forHeaderFooterViewReuseIdentifier: RMLoadingFooterTableView.cellIdentifier
        )
        tableView.sectionHeaderTopPadding = 0
        tableView.isHidden = true
        tableView.alpha = 0
        return tableView
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
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.Identifier
        )
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.Identifier
        )
        collectionView.register(
            RMLoadingFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMLoadingFooterCollectionResuableView.Identifier
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(tableView, collectionView)
        viewModel.delegate = self
        setUpTableView()
        setUpCollectionView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            // For locations
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            
            // For Episodes and characters
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func setUpTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
    
    func configure(with searchResult: RMSearchResultType) {
        viewModel.configure(with: searchResult)
    }
}

extension RMSearchResultsView: RMSearchResultViewViewModelDelegate {
    
    func didLoadLocations() {
        tableView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.tableView.alpha = 1
        }
        tableView.reloadData()
    }
    
    func didLoadCharactersOrEpisodes() {
        collectionView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 1
        }
        collectionView.reloadData()
    }
    
    func didSelectLocation(with model: RMLocation) {
        delegate?.didSelect(with: model)
    }
    
    func didSelectCharacter(with model: RMCharacter) {
        delegate?.didSelect(with: model)
    }
    
    func didSelectEpisode(with model: RMEpisode) {
        delegate?.didSelect(with: model)
    }
    
    func didLoadMoreLocations(at indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            self.tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func didLoadMoreCharactersOrEpisodes(at indexPaths: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: indexPaths)
        }
    }
}
