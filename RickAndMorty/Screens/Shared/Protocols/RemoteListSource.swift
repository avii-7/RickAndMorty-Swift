//
//  ListRepository.swift
//  RickAndMorty
//
//  Created by Arun on 06/02/24.
//

import Foundation
import Networking

protocol RemoteListSource: Sendable {
    
    func fetch<T: Decodable>(endPoint: RMNetworkEndpoint) async throws -> Result<T, NetworkError>
    
    func fetchAdditional<T: Decodable>(using urlString: String) async throws -> Result<T, NetworkError>
}

protocol RemoteListSourceV2: Sendable {
    
    func fetch<T>(endPoint: NetworkEndpoint) async throws(Networking.NetworkError) -> T where T : Decodable
}

protocol CharacterListSource: Sendable {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters
}

struct DefaultCharacterListSource: CharacterListSource {
    
    private let remoteListSource: RemoteListSourceV2
    
    init(remoteListSource: RemoteListSourceV2) {
        self.remoteListSource = remoteListSource
    }
    
    func fetchAllCharacters(pageNo: Int? ) async throws -> RMAllCharacters {
        try await remoteListSource.fetch(endPoint: .characters(pageNo: pageNo))
    }
}

struct MockCharacterListSource: CharacterListSource {
    
    func fetchAllCharacters(pageNo: Int?) async throws -> RMAllCharacters {
        .dummy
    }
}
