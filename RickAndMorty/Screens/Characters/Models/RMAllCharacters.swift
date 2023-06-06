//
//  RMAllCharacters.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import Foundation

struct RMAllCharacters: Codable {
    let info: Info
    let results: [RMCharacter]
}

struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
