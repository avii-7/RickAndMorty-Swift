//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import Foundation

final class RMCharacterDetailViewModel {
    
    private let character: RMCharacter
    
    init(_ character: RMCharacter) {
        self.character = character
    }
    
    var name: String {
        character.name
    }
}
