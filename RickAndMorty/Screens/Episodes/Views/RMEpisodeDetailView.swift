//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import UIKit

@MainActor
protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEpisodeDetailView(didSelectCharacter character: RMCharacter)
}

final class RMEpisodeDetailView: UIView {
    
    private var sections = [SectionType]()
    
    private var characters = [RMCharacter]()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // Why i need Implicitly unwrapped optional here ?
    private var collectionView: UICollectionView!
    
    private let viewModel: RMEpisodeDetailViewViewModel
    
    weak var delegate: RMEpisodeDetailViewDelegate?
    
    init(viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        collectionView = createCollectionView()
        addSubviews(spinner, collectionView)
        addConstraints()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Functions
    @MainActor
    func loadData() {
        spinner.startAnimating()
        
        Task { /*@MainActor*/ [weak self] in
            
            guard let self else { return }
            
            do {
                if await viewModel.isEpisodeInitialized == false {
                    try await viewModel.setEpisode()
                }
                
                try await fetchRelatedCharacters()
                
                try await createSections()
                
                spinner.stopAnimating()
                collectionView.isHidden = false
                collectionView.reloadData()
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.alpha = 1
                }
            }
            catch {
                debugPrint("Error \(error)")
            }
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
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.Identifier)
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
        let sections = sections
        
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
                widthDimension: .fractionalWidth(UIDevice.isIphone ?  0.5 : 0.25),
                heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = .init(top: 10, leading: 10, bottom: 0, trailing: 0)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(260)),
            subitems: UIDevice.isIphone ? [item, item] : [item, item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension RMEpisodeDetailView : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = sections[indexPath.section]
        
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
                withReuseIdentifier: RMCharacterCollectionViewCell.Identifier,
                for: indexPath) as? RMCharacterCollectionViewCell
            else { fatalError("Something went wrong") }
            cell.configure(with: viewModels[indexPath.row])
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .characters:
            guard let character = character(at: indexPath.row) else { return }
            delegate?.rmEpisodeDetailView(didSelectCharacter: character)
        default:
            break
        }
    }
}


extension RMEpisodeDetailView {
    
    func createSections() async throws {
        if sections.isEmpty == false {
            sections.removeAll()
        }
        
        self.sections = try await viewModel.getSections(for: characters)
    }
    
    func fetchRelatedCharacters() async throws {
        if characters.isEmpty == false {
            characters.removeAll()
        }
        
        self.characters = try await viewModel.getRelatedCharacters()
    }
    
    func character(at index: Int) -> RMCharacter? {
        
        if characters.isEmpty {
            return nil
        }
        
        let character = characters[index]
        return character
    }
}
