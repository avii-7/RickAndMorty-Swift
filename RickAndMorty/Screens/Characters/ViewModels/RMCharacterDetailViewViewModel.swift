//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    var sections: [SectionTypes] = []
    
    // MARK: - Initializer
    
    init(with character: RMCharacter) {
        self.character = character
        setUpSections()
    }
    
    var name: String {
        character.name
    }
    
    private func setUpSections() {
        
        if let imageURL = URL(string: character.image) {
            sections.append(.photo(viewModel: .init(imageUrl: imageURL)))
        }
        
        sections.append(.information(
            viewModel: [
                .init(type: .status, value: character.status.rawValue),
                .init(type: .gender, value: character.gender.rawValue),
                .init(type: .type, value: character.type),
                .init(type: .species, value: character.species),
                .init(type: .origin, value: character.origin.name),
                .init(type: .location, value: character.location.name),
                .init(type: .created, value: character.created),
                .init(type: .episodeCount, value: "\(character.episode.count)")
            ]
        ))
        
        sections.append(.episodes(
            viewModel: character.episode.compactMap({
                if let episodeURL = URL(string: $0) {
                    return RMEpisodeCollectionViewCellViewModel(episodeUrl: episodeURL)
                }
                return nil
            })
        ))
    }
}
