//
//  CharacterListSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 28/10/25.
//

import Networking

protocol CharactersSource: Sendable {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters
    
    func fetchEpisode(using url: String) async throws -> RMEpisode
}

struct DefaultCharactersSource: CharactersSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters {
        let request = CharactersHTTPRequest.characters(pageNo: pageNo)
        let response: RMAllCharacters = try await httpClient.execute(httpRequest: request)
        return response
    }
    
    func fetchEpisode(using url: String) async throws -> RMEpisode {
        let request = CharactersHTTPRequest.episode(url: url)
        let response: RMEpisode = try await httpClient.execute(httpRequest: request)
        return response
    }
}

struct MockCharactersSource: CharactersSource {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters {
        .dummy
    }
    
    func fetchEpisode(using url: String) async throws -> RMEpisode {
        guard let lastCharacter = url.last else {
            return .get(with: 1)
        }
        
        let lastCharacterString = String(lastCharacter)
        
        if let index = Int(lastCharacterString) {
            return .get(with: index)
        }
        
        return .get(with: 1)
    }
}
