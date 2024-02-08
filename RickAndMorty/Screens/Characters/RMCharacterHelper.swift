//
//  RMCharacterHelper.swift
//  RickAndMorty
//
//  Created by Arun on 08/02/24.
//

import Foundation

struct RMCharacterHelper {
    
    static func createCellViewModels(from characters: [RMCharacter]) -> [RMCharacterCollectionViewCellViewModel] {
        
        var cellViewModels = [RMCharacterCollectionViewCellViewModel]()
        
        characters.forEach { character in
            let cellViewModel = RMCharacterCollectionViewCellViewModel(id: character.id, name: character.name, status: character.status, imageUrlString: character.image)
            cellViewModels.append(cellViewModel)
        }
        
        return cellViewModels
    }
}

enum SectionTypes {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
    case information(viewModel: [RMCharacterInfoCollectionViewCellViewModel])
    case episodes(viewModel: [RMEpisodeCollectionViewCellViewModel])
}

