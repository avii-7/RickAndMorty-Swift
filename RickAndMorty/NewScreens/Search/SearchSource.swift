//
//  SearchSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 11/11/25.
//

import Networking
import Foundation

protocol SearchSource: Sendable {
    
    func searchCharacter(query: String, page: Int?) async throws -> RMAllCharacters
    
    func searchEpisode(query: String, page: Int?) async throws -> RMAllEpisodes

    func searchLocation(query: String, page: Int?) async throws -> RMAllLocations
}

struct DefaultSearchSource: SearchSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func searchCharacter(query: String, page: Int? = nil) async throws -> RMAllCharacters {
        let request: SearchHTTPRequest = .character(query: query, page: page)
        let response: RMAllCharacters = try await httpClient.execute(httpRequest: request)
        return response
    }
    
    func searchEpisode(query: String, page: Int? = nil) async throws -> RMAllEpisodes {
        let request: SearchHTTPRequest = .episode(query: query, page: page)
        let response: RMAllEpisodes = try await httpClient.execute(httpRequest: request)
        return response
    }
    
    func searchLocation(query: String, page: Int?) async throws -> RMAllLocations {
        let request: SearchHTTPRequest = .location(query: query, page: page)
        let response: RMAllLocations = try await httpClient.execute(httpRequest: request)
        return response
    }
}
