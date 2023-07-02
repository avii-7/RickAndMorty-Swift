//
//  RMCharacterHelperClass.swift
//  RickAndMorty
//
//  Created by Arun on 19/06/23.
//

import Foundation

enum SectionTypes {
    case photo(viewModel: RMCharacterPhotoCollectionViewCellViewModel)
    case information(viewModel: [RMCharacterInfoCollectionViewCellViewModel])
    case episodes(viewModel: [RMCharacterEpisodeCollectionViewCellViewModel])
}
