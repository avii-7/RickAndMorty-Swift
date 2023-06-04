//
//  Location.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct Location: Codable
{
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: [String]
    let created: String
}
