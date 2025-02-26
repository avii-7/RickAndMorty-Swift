//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 05/07/23.
//

import Foundation

/// View model to handle character list logic
final class RMEpisodeListViewViewModel: NSObject, Sendable {
    
    let listSource: RemoteListSource
    
    init(listSource: RemoteListSource) {
        self.listSource = listSource
    }
    
    func fetchInitialEpisodes() async throws -> Result<RMAllEpisodes, NetworkError> {
        let response: Result<RMAllEpisodes, NetworkError> = try await listSource.fetch(endPoint: .episode)
        return response
    }
    
    func fetchAdditionalEpisodes(urlString: String) async throws -> Result<RMAllEpisodes, NetworkError> {
        let response: Result<RMAllEpisodes, NetworkError> = try await listSource.fetchAdditional(using: urlString)
        return response
    }
}
