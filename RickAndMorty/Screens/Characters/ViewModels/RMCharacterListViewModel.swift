//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import UIKit

final class RMCharacterListViewModel: NSObject {
    
    private var model: RMAllCharacters?
    private var characters: [RMCharacter]?
    
    func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequest, expecting: RMAllCharacters.self) { result in
            switch result {
            case .success(let model):
                self.model = model
                self.characters = model.results
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
     
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //characters?.count ?? 0
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported Cell")
        }
        guard let characters else { return cell }
        
        let viewModel = RMCharacterCollectionViewCellViewModel(
            characterName: characters[indexPath.row].name,
            //characterStatus: characters[indexPath.row].status,
            characterStatus: RMCharacterStatus.alive,
            characterImageUrl: URL(string: characters[indexPath.row].image))
        
        cell.configure(with: viewModel)
        cell.backgroundColor = .purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        
        return CGSize(width: width, height: width * 1.5)
    }
    
}
