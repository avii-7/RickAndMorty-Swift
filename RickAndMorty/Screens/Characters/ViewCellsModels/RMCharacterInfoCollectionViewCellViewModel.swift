//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    private let title: String
    private let value: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
