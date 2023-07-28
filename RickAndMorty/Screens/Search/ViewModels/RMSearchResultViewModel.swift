//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 26/07/23.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case locations([RMLocationCellViewViewModel])
    case episodes([RMEpisodeCollectionViewCellViewModel])
}
