//
//  Episode.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct RMEpisode: Decodable, RMEpisodeDataRenderer, Identifiable {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
    let characters: [String]
    let url: String
    let created: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, episode, characters, url, created
        case airDate = "air_date"
    }
}

extension RMEpisode {
    
    static func getAll() -> [RMEpisode] {
        (1...10).map(Self.get)
    }
    
    static func get(with index: Int) -> RMEpisode {
        RMEpisode(
            id: index,
            name: "Close Rick-counters of the Rick Kind",
            airDate: Date.now.description,
            episode: "S01E\(index)",
            characters: RMCharacter.getAllDefault().compactMap({ $0.url?.absoluteString }),
            url: "https://rickandmortyapi.com/api/episode/\(index)",
            created: Date.now.description
        )
    }
}

enum EpisodeInfoType: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case name = "Name"
    case episode = "Episode"
    case airDate = "Air Date"
    case created = "Created"
    
    func getValue(from episode: RMEpisode) -> String {
        switch self {
        case .name: episode.name
        case .episode: episode.episode
        case .airDate: episode.airDate
        case .created: episode.created
        }
    }
}
