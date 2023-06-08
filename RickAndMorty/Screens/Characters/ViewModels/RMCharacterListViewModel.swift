//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import UIKit


protocol RMCharacterListViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didSelectCharacter(_ character: RMCharacter)
}

/// View model to handle character list logic
final class RMCharacterListViewModel: NSObject {
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let cellViewModel = RMCharacterCollectionViewCellViewModel(name: character.name, status: character.status, imageUrlString: character.image)
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    public weak var delegate: RMCharacterListViewModelDelegate?
    
    private var allCharacterInfo: Info?
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMAllCharacters.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.characters = model.results
                self.allCharacterInfo = model.info
                DispatchQueue.main.async {
                    self.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if possible
    func fetchAdditionalCharacters() {
         
    }
    
    var shouldShowLoadMoreIndicator: Bool {
        allCharacterInfo?.next != nil
    }
}

// MARK: - CollectionView

extension RMCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
}

extension RMCharacterListViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator else { return }
        
    }
}
