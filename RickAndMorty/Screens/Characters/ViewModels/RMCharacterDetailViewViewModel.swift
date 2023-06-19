//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    enum RMCharacterDetailSectionTypes: CaseIterable {
        case photo, information, episodes
    }
    
    var sections: [RMCharacterDetailSectionTypes] {
        RMCharacterDetailSectionTypes.allCases
    }

    
    init(_ character: RMCharacter) {
        self.character = character
    }
    
    var name: String {
        character.name
    }
}
