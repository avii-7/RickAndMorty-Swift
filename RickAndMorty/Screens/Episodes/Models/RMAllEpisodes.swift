//
//  RMAllEpisodes.swift
//  RickAndMorty
//
//  Created by Arun on 05/07/23.
//

import Foundation

struct RMAllEpisodes: Codable, Pagination {
    let info: RMInfo
    let results: [RMEpisode]
}
