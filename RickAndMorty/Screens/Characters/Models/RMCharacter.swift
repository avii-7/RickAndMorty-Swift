//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

enum CharacterInfoType: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case status = "Status"
    case gender = "Gender"
    case type = "Type"
    case species = "Species"
    case origin = "Origin"
    case location = "Location"
    case created = "Created"
    case episodeCount = "Episodes Count"
    
    func getSystemImageName(using model: RMCharacter) -> String {
        switch self {
        case .status: self.getSystemImage(using: model.status)
        case .gender: self.getSystemImage(using: model.gender)
        case .type: "atom"
        case .species: model.species.caseInsensitiveCompare("Human") == .orderedSame ? "person" : "circle.dotted.and.circle"
        case .origin: "globe.americas.fill"
        case .location: "mappin.and.ellipse"
        case .created: "calendar"
        case .episodeCount: "number"
        }
    }
    
    private static let unknownSystemImage = "questionmark.circle.fill"
    
    private func getSystemImage(using status: RMCharacterStatus) -> String {
        switch status {
        case .alive: "heart.fill"
        case .dead: "heart.slash.fill"
        case .unknown: Self.unknownSystemImage
        }
    }
    
    private func getSystemImage(using status: RMCharacterGender) -> String {
        switch status {
        case .male: "figure.stand"
        case .female: "figure.stand.dress"
        case .genderless: "figure.stand.dress.line.vertical.figure"
        case .unknown: Self.unknownSystemImage
        }
    }
    
    func getValue(using model: RMCharacter) -> String {
        switch self {
        case .status: model.status.rawValue
        case .gender: model.gender.rawValue
        case .type: model.type
        case .species: model.species
        case .origin: model.origin.name
        case .location: model.location.name
        case .created: model.created
        case .episodeCount: String(model.episode.count)
        }
    }
}

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
    
    static func getAllDefault() -> [RMCharacter] {
        return (1...10).map { index in
            getDefault(index: index)
        }
    }
    
    static func getDefault(index: Int) -> RMCharacter {
        .init(
            id: index,
            name: "Rick Sanchez \(Bool.random() ? "" : String(index))",
            status: Bool.random() ? .alive: .dead,
            species: "Human",
            type: .empty,
            gender: .male,
            origin: .init(name: .empty, url: .empty),
            location: .init(name: .empty, url: .empty),
            image: "https://rickandmortyapi.com/api/character/avatar/\(index).jpeg",
            episode: (1...10).map { "https://rickandmortyapi.com/api/episode/\($0)" },
            url: URL(string: "https://rickandmortyapi.com/api/character/\(index)"),
            created: .empty
        )
    }
}

enum RMCharacterStatus: String, Codable, Hashable {
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

enum RMCharacterGender: String, Codable, Hashable {
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
