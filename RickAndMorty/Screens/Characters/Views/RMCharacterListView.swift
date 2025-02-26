//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import UIKit

@MainActor
protocol RMCharacterListViewDelegate: AnyObject {
    func rmCharacterListView(didSelectCharacter character: RMCharacter)
}

/// Custom view that showing list of characters, loader, infinite loading etc
final class RMCharacterListView: UIView {

    var viewModel: RMCharacterListViewViewModel?
    
    private var nextURL: String?
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var characters = [RMCharacter]()
    
    private var fetchingMoreCharacterStatus = fetchStatus.notYetStarted
    
    weak var delegate: RMCharacterListViewDelegate?
    
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
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.Identifier)
        
        collectionView.register(
            RMLoadingFooterCollectionResuableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMLoadingFooterCollectionResuableView.Identifier
        )
        return collectionView
    }()
    
    // MARK: - Int
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectionView, spinner)
        addConstraints()
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
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func loadInitialCharacters() {
        spinner.startAnimating()
        Task { @MainActor in
            
            if let viewModel {
                do {
                    let response = try await viewModel.fetchInitialCharacters()
                    
                    switch response {
                    case .success(let rmAllCharacters):
                        nextURL = rmAllCharacters.info.next
                        self.characters.append(contentsOf: rmAllCharacters.results)
                        let cellViewModels = RMCharacterHelper.createCellViewModels(from: characters)
                        self.cellViewModels.append(contentsOf: cellViewModels)
                    case .failure(let error):
                        throw error
                    }
                }
                catch {
                    debugPrint("Error \(error.localizedDescription)")
                }
            }
            
            spinner.stopAnimating()
            collectionView.isHidden = false
            collectionView.reloadData()
            UIView.animate(withDuration: 0.4) {
                self.collectionView.alpha = 1
            }
        }
    }
}

extension RMCharacterListView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.Identifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell !!")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = collectionView.bounds
        var width: CGFloat
        
        if UIDevice.isIphone {
            width = (bounds.width - 30) / 2
        }
        else{
            // iPad
            width = (bounds.width - 60 )/4
        }
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        delegate?.rmCharacterListView(didSelectCharacter: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionFooter,
              let supplementaryFooterView = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "RMLoadingFooterCollectionResuableView",
                for: indexPath) as? RMLoadingFooterCollectionResuableView
        else {
            fatalError("Unable to get reusable footer view")
        }
        supplementaryFooterView.startAnimating()
        return supplementaryFooterView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if nextURL != nil {
            return CGSize(width: collectionView.frame.width, height: 100)
        }
        else {
            return CGSize.zero
        }
    }
}

extension RMCharacterListView: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            checkReachAtBottom(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkReachAtBottom(scrollView)
    }
    
    private func checkReachAtBottom(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + 1 >= (scrollView.contentSize.height - scrollView.frame.height - 120) {
            
            if let nextURL, fetchingMoreCharacterStatus != .inProgress, viewModel != nil {
                
                fetchingMoreCharacterStatus = .inProgress

                Task { @MainActor in
                    
                    if let viewModel {
                        
                        let response = try await viewModel.fetchAdditionalCharacters(urlString: nextURL)
                        
                        let cellViewModels: [RMCharacterCollectionViewCellViewModel]?
                        
                        switch response {
                        case .success(let rmAllCharacters):
                            self.nextURL = rmAllCharacters.info.next
                            let newCharacters = rmAllCharacters.results
                            self.characters.append(contentsOf: newCharacters)
                            cellViewModels = RMCharacterHelper.createCellViewModels(from: newCharacters)
                        case .failure(let error):
                            debugPrint("Error \(error.localizedDescription)")
                            cellViewModels = nil
                        }
                        
                        if let cellViewModels {
                            let startIndex = self.cellViewModels.endIndex
                            self.cellViewModels.append(contentsOf: cellViewModels)
                            let endIndex = self.cellViewModels.endIndex - 1
                            let indexPaths = RMSharedHelper.getIndexPaths(start: startIndex, end: endIndex)
                            
                            collectionView.performBatchUpdates {
                                collectionView.insertItems(at: indexPaths)
                            }
                        }
                    }
                    
                    fetchingMoreCharacterStatus = .finished
                }
            }
        }
    }
}

