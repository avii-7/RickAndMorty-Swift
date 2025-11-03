//
//  RMAllLocations.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import Foundation

struct RMAllLocations: Decodable {
    let info: RMInfo
    let results: [RMLocation]
}
