//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import UIKit

protocol RMCharacterDetailViewDelegate: AnyObject  {
    func didSelectItem(indexPath: IndexPath)
}

final class RMCharacterDetailView: UIView {
    
    private var collectionView: UICollectionView!
    
    private let viewModel: RMCharacterDetailViewViewModel
    
     weak var delegate: RMCharacterDetailViewDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Int
    
    init(frame: CGRect, _ viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        collectionView = createCollectionView()
        addSubviews(spinner, collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(
            RMCharacterPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIndentifier
        )
        collectionView.register(
            RMCharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIndentifier
        )
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
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
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        
        let sections = viewModel.sections
        
        switch sections[sectionIndex] {
        case .photo:
            return viewModel.createPhotoSectionLayout()
        case .information:
            return viewModel.createInformationSectionLayout()
        case .episodes:
            return viewModel.createEpisodeSectionLayout()
        }
    }
}

// MARK: - CollectionView

extension RMCharacterDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModels):
            return viewModels.count
        case .episodes(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.sections[indexPath.section]
        
        switch section {
            
        case .photo(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIndentifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModel)
            return cell
            
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIndentifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(indexPath: indexPath)
    }
}
