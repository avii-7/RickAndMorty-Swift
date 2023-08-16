//
//  SearchResultsView.swift
//  RickAndMorty
//
//  Created by Arun on 28/07/23.
//

import UIKit

final class RMSearchResultsView: UIView {
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private var locationCellViewViewModels: [RMLocationCellViewViewModel] = [] {
        didSet {
            configureTableView()
        }
    }
    
    private var collectionViewCellViewModels: [any Hashable]?
    
    internal weak var delegate: RMSelectionDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RMLocationTableViewCell.self,
                           forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
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
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(
            RMLoadingFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "RMLoadingFooterCollectionResuableView"
        )
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(tableView, collectionView)
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
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
        case .characters(let viewModels):
            configureCollectionView()
        case .locations(let locationCellViewViewModels):
            self.locationCellViewViewModels = locationCellViewViewModels
        case .episodes(let viewModels):
            configureCollectionView()
        }
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureTableView() {
        tableView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.tableView.alpha = 1
        }
        tableView.reloadData()
    }
    
    private func configureCollectionView() {
        collectionView.isHidden = false
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 1
        }
        collectionView.reloadData()
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Location search result view
extension RMSearchResultsView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationCellViewViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath
        ) as? RMLocationTableViewCell else { fatalError("Something goes wrong !") }
        cell.config(with: locationCellViewViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelect(with: indexPath)
    }
}

// MARK: - Character and episodes search result view

extension RMSearchResultsView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .zero
    }
}
