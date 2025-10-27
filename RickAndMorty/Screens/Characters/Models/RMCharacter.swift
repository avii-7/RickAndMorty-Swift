//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct RMCharacter: Decodable, Identifiable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: RMCharacterGender
    let origin: RMCharacterOrigin
    let location: RMCharacterLocation
    let image: String
    let episode: [String]
    let url: URL?
    let created: String
}

extension RMCharacter {
    
    static func getDefault() -> RMCharacter {
        
        .init(
            id: 1,
            name: "Rick Sanchez",
            status: .alive,
            species: "Human",
            type: .empty,
            gender: .male,
            origin: .init(name: .empty, url: .empty),
            location: .init(name: .empty, url: .empty),
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            episode: (1...10).map { "https://rickandmortyapi.com/api/episode/\($0)" },
            url: URL(string: "https://rickandmortyapi.com/api/character/1"),
            created: .empty
        )
    }
}

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
    
    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

enum RMCharacterGender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = "unknown"
}

struct RMCharacterOrigin: Codable {
    let name: String
    let url: String
}

struct RMCharacterLocation: Codable {
    let name: String
    let url: String
}
