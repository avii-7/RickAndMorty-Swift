//
//  RMAllCharacters.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import Foundation

struct RMAllCharacters: Decodable {
    
    let info: RMInfo
    let results: [RMCharacter]
}
         
extension RMAllCharacters {
    
    static var dummy: RMAllCharacters {
        .init(
            info: RMInfo(
                count: 10,
                pages: 10,
                next: "https://rickandmortyapi.com/api/character/?page=2",
                prev: nil
            ),
            results: RMCharacter.getAllDefault()
        )
    }
}
