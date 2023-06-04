//
//  Character.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: CharacterOrigin
    let location: CharacterLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

enum CharacterStatus: String, Codable {
    case alive = "alive"
    case dead = "dead"
    case unknown = "unknown"
}

enum CharacterGender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown = " unkown"
}

struct CharacterOrigin: Codable {
    let name: String
    let url: String
}

struct CharacterLocation: Codable {
    let name: String
    let url: String
}
