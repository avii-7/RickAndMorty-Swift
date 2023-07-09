//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEpisodeDetailView(didSelect character: RMCharacter)
}

final class RMEpisodeDetailView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // Why i need Implicitly unwrapped optional here ?
    private var collectionView: UICollectionView!
    
    private var viewModel: RMEpisodeDetailViewViewModel?
    
    public weak var delegate: RMEpisodeDetailViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        collectionView = createCollectionView()
        addSubviews(spinner, collectionView)
        addConstraints()
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Public function
    
    public func configure(viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
        spinner.stopAnimating()
        collectionView.isHidden = false
        // do we actually need to reload data ?
        collectionView.reloadData()
        UIView.animate(withDuration: 0.5) {
            self.collectionView.alpha = 1
        }
    }
    
    //MARK: - Private function
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            self.getCollectionViewLayout(for: section)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
}

// MARK: - Collection View Layouts
extension RMEpisodeDetailView {
    
    private func getCollectionViewLayout(for section: Int) -> NSCollectionLayoutSection {
        guard let viewModel else {
            return getEpisodeInfoLayout()
        }
        let sections = viewModel.cellViewModels
        switch sections[section] {
        case .information:
            return getEpisodeInfoLayout()
        case .characters:
            return getCharacterLayout()
        }
    }
    
    private func getEpisodeInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0))
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(100)),
            subitems: [item])
        group.contentInsets = .init(top: 0, leading: 10, bottom: 10, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func getCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(260)),
            subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}

extension RMEpisodeDetailView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel else { fatalError("No View Models !") }
        
        let sectionType = viewModel.cellViewModels[indexPath.section]
        
        switch sectionType {
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMEpisodeInfoCollectionViewCell
            else { fatalError("Something went wrong") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        case .characters(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell
            else { fatalError("Something went wrong") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.cellViewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        let sectionType = viewModel.cellViewModels[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel else { return }
        let sectionType = viewModel.cellViewModels[indexPath.section]
        switch sectionType {
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else { return }
            delegate?.rmEpisodeDetailView(didSelect: character)
            break
        case .information:
            break
        }
    }
}
