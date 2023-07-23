//
//  EnumsHelper.swift
//  RickAndMorty
//
//  Created by Arun on 21/07/23.
//

import Foundation

enum RMModuleType {
    case Character
    case Location
    case Episode
    
    var endPoint: RMEndpoint {
        switch self {
        case .Character:
            return .character
        case .Location:
            return .location
        case .Episode:
            return .episode
        }
    }
}
