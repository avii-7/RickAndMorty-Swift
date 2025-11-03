//
//  Location.swift
//  RickAndMorty
//
//  Created by Arun on 04/06/23.
//

import Foundation

struct RMLocation: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}

enum LocationInfoType: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case name = "Name"
    case type = "Type"
    case dimension = "Dimension"
    case created = "Created"
    
    func getValue(from location: RMLocation) -> String {
        switch self {
        case .name: location.name
        case .type: location.type
        case .dimension: location.dimension
        case .created: location.created
        }
    }
}

extension RMLocation {
    
    static var `default`: RMLocation {
        RMLocation(
            id: .random(in: 1...10),
            name: "Mars",
            type: "Planet",
            dimension: .empty,
            residents: [],
            url: .empty,
            created: Date.now.description
        )
    }
}
