//
//  RMAllCharacters.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import Foundation

protocol RMInfoResults: Decodable {
    
    associatedtype T: Identifiable, Decodable
    
    var info: RMInfo { get }
    
    var results: [T] { get }
}

struct RMAllCharacters: Decodable, RMInfoResults {
    
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
