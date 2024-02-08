//
//  RMEpisodeHelper.swift
//  RickAndMorty
//
//  Created by Arun on 08/02/24.
//

import Foundation

struct RMEpisodeHelper {
    
    static func createCellViewModels(from episodes: [RMEpisode]) -> [RMEpisodeCollectionViewCellViewModel] {
        
        var cellViewModels = [RMEpisodeCollectionViewCellViewModel]()
        
        episodes.forEach { episode in
            let url = URL(string: episode.url)
            let cellViewModel = RMEpisodeCollectionViewCellViewModel(
                episodeUrl: url,
                borderColor: RMSharedHelper.randomColor)
            cellViewModels.append(cellViewModel)
        }
        
        return cellViewModels
    }
}
