//
//  Episode.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct RMEpisode: Codable
{
    let id: Int
    let name: String
    let air_date: String
    let episode: String
    let characters: [String]
    let url: [String]
    let created: String
}
