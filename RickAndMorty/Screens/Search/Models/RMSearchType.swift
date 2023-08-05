//
//  RMSearchType.swift
//  RickAndMorty
//
//  Created by Arun on 21/07/23.
//

import Foundation

struct RMSearchType {
    let moduleType: RMModuleType
    
    var displayTitle: String {
        switch moduleType {
        case .Character:
            return "Search Characters"
        case .Location:
            return "Search Locations"
        case .Episode:
            return "Search Episodes"
        }
    }
}
