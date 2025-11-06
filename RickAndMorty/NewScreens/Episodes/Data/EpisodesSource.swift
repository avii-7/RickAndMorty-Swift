//
//  EpisodesSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 04/11/25.
//

import Networking

protocol EpisodesSource: Sendable {
    
    func fetchAllEpisodes(pageNo: Int?) async throws -> RMAllEpisodes
    
    func fetchCharacter(using url: String) async throws -> RMCharacter
}

struct DefaultEpisodesSource: EpisodesSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchAllEpisodes(pageNo: Int?) async throws -> RMAllEpisodes {
        let request = EpisodesHTTPRequest.allEpisodes(pageNo: pageNo)
        let response: RMAllEpisodes = try await httpClient.execute(httpRequest: request)
        return response
    }
    
    func fetchCharacter(using url: String) async throws -> RMCharacter {
        let request = EpisodesHTTPRequest.character(url: url)
        let response: RMCharacter = try await httpClient.execute(httpRequest: request)
        return response
    }
}

//struct MockEpisodesSource: EpisodesSource {
//    
//    func fetchAllEpisodes(pageNo: Int?) async throws -> RMAllEpisodes {
////        .dummy
//    }
//    
//    func fetchCharacter(using url: String) async throws -> RMCharacter {
//       
//    }
//}
