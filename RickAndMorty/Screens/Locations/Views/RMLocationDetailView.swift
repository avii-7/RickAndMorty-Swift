//
//  RMLocationDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 19/07/23.
//

import UIKit

protocol RMLocationDetailViewDelegate: AnyObject {
    func rmLocationDetailView(didSelectResident resident: RMCharacter)
}

final class RMLocationDetailView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // Why i need Implicitly unwrapped optional here ?
    private var collectionView: UICollectionView!
    
     weak var delegate: RMLocationDetailViewDelegate?
    
    private let viewModel: RMLocationDetailViewViewModel
    
    private var sections = [RMLocationDetailSection]()
    
    private var residents = [RMCharacter]()
    
    init(viewModel: RMLocationDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        collectionView = createCollectionView()
        addSubviews(spinner, collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
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
    
    func loadData() {
        spinner.startAnimating()
        Task { @MainActor [weak self] in
            do {
                let residents = try await self!.viewModel.getResidents()
                self?.residents.append(contentsOf: residents)
                guard let self else { return }
                
                let sections = RMLocationHelper.getSections(location: viewModel.location, residents: residents)
                self.sections.append(contentsOf: sections)
                
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
}

extension RMLocationDetailView : UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        
        let section = sections[section]
        switch section {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        switch section {
        case .characters:
            let resident = residents[indexPath.row]
            delegate?.rmLocationDetailView(didSelectResident: resident)
            break
        case .information:
            break
        }
    }
}

// MARK: - Collection View Layouts
extension RMLocationDetailView {
    
    private func getCollectionViewLayout(for sectionIndex: Int) -> NSCollectionLayoutSection {
        switch sections[sectionIndex] {
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
