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
    func didLoadMoreCharacters(at indexPaths: [IndexPath])
}

enum FetchingMoreCharactersStatus {
    case notYetStarted, inProgress, finished, failed
}
/// View model to handle character list logic
final class RMCharacterListViewModel: NSObject {
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters where
            !cellViewModels.contains(where: { $0.id == character.id }) {
                let cellViewModel = RMCharacterCollectionViewCellViewModel(id: character.id, name: character.name, status: character.status, imageUrlString: character.image)
                cellViewModels.append(cellViewModel)
            }
        }
    }
    
    private var fetchingMoreCharacterStatus: FetchingMoreCharactersStatus = .notYetStarted
    
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
    func fetchAdditionalCharacters(url: URL) {
        fetchingMoreCharacterStatus = .inProgress
        
        guard let request = RMRequest(url: url) else {
            fetchingMoreCharacterStatus = .failed
            return
        }
        
        RMService.shared.execute(request, expecting: RMAllCharacters.self) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let responseModel):
                self.allCharacterInfo = responseModel.info
                
                let startIndex = self.characters.endIndex
                self.characters.append(contentsOf: responseModel.results)
                let endIndex = self.characters.endIndex - 1
                
                let indexPathToAdd = Array(startIndex...endIndex).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(at: indexPathToAdd)
                    self.fetchingMoreCharacterStatus = .finished
                }
            case .failure(let failure):
                self.fetchingMoreCharacterStatus = .failed
                print(" Failed \(failure.localizedDescription)")
            }
        }
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
        guard shouldShowLoadMoreIndicator else {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension RMCharacterListViewModel: UIScrollViewDelegate {
    
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
            guard shouldShowLoadMoreIndicator,
            fetchingMoreCharacterStatus != .inProgress,
            let urlString = allCharacterInfo?.next,
            let url = URL(string: urlString)
            else { return }
            fetchAdditionalCharacters(url: url)
        }
    }
}
