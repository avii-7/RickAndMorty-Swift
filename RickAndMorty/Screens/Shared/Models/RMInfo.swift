//
//  Models.swift
//  RickAndMorty
//
//  Created by Arun on 07/07/23.
//

import Foundation

struct RMInfo: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
