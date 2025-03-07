//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import Foundation

/// Represents unqiue API endpoints
enum RMEndpoint: String, Hashable, CaseIterable {
    /// Endpoint to get character information
    case character
    /// Endpoint to get location information
    case location
    /// Endpoint to get episode information
    case episode
}
