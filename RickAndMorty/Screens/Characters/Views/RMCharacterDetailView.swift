//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import UIKit

protocol RMCharacterDetailViewDelegate: AnyObject  {
    func rmCharacterDetailView(didSelectEpisode episodeViewModel: RMEpisodeCollectionViewCellViewModel)
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
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        collectionView = createCollectionView()
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground

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
            forCellWithReuseIdentifier: RMCharacterPhotoCollectionViewCell.Indentifier
        )
        collectionView.register(
            RMCharacterInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterInfoCollectionViewCell.Indentifier
        )
        collectionView.register(
            RMEpisodeCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeCollectionViewCell.Identifier
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
            return createPhotoSectionLayout()
        case .information:
            return createInformationSectionLayout()
        case .episodes:
            return createEpisodeSectionLayout()
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.Indentifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModel)
            return cell
            
        case .information(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.Indentifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
            
        case .episodes(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeCollectionViewCell.Identifier, for: indexPath) as? RMEpisodeCollectionViewCell else { fatalError("Supported went wrong.") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sectionType = viewModel.sections[indexPath.section]
       
        switch sectionType {
        case .episodes(let viewModel):
            let episodeViewModel = viewModel[indexPath.row]
            delegate?.rmCharacterDetailView(didSelectEpisode: episodeViewModel)
        default:
            break
        }
    }
}

extension RMCharacterDetailView {
    
    // MARK: - Collection View Section Layouts.
    
    func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(UIDevice.isIphone ? 0.5 : 0.4)
            ),
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(
            top: 0, leading: 0,
            bottom: 5, trailing: 0
        )
        
        return section
    }
    
    func createInformationSectionLayout() -> NSCollectionLayoutSection {
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = .init(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isIphone ? [item, item] : [item, item, item, item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        return section
    }
    
    func createEpisodeSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        item.contentInsets = .init(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(UIDevice.isIphone ? 0.8 : 0.4),
                heightDimension: .absolute(150)
            ),
            subitems: UIDevice.isIphone ? [item] : [item, item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        return section
    }
}
