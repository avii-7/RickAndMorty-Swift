//
//  CharacterListSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 28/10/25.
//

import Networking

protocol CharacterListSource: Sendable {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters
}

struct DefaultCharacterListSource: CharacterListSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchAllCharacters(pageNo: Int? ) async throws -> RMAllCharacters {
        let request = NetworkEndpoint.characters(pageNo: pageNo)
        let response: RMAllCharacters = try await httpClient.execute(httpRequest: request)
        return response
    }
}

struct MockCharacterListSource: CharacterListSource {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters {
        .dummy
    }
}
