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
            if let url = URL(string: episode.url) {
                let cellViewModel = RMEpisodeCollectionViewCellViewModel(
                    episodeUrl: url)
                cellViewModels.append(cellViewModel)
            }
        }
        return cellViewModels
    }

    static func createCellViewModels(from dataTuple: (RMEpisode, [RMCharacter])) -> [SectionType] {
        let episode = dataTuple.0
        let characters = dataTuple.1

        let formattedDate = RMDateFormatter.getFormattedDate(for: episode.created)
        
        let cellViewModels: [SectionType] = [
            .information(viewModel:[
                .init(title: "Name", value: episode.name),
                .init(title: "Air date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: formattedDate)
            ]),
            .characters(viewModel: characters.compactMap({
                RMCharacterCollectionViewCellViewModel(
                    id: $0.id,
                    name: $0.name,
                    status: $0.status,
                    imageUrlString: $0.image
                )
            }))
        ]
        return cellViewModels
    }
}
