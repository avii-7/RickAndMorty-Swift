//
//  EpisodeDataRepository.swift
//  RickAndMorty
//
//  Created by Arun on 03/02/24.
//

import Foundation

final class RMEpisodeDataRepository {
    
    private let baseNetworkList = BaseNetworkListRepository()
    
    func fetchInitialEpisodes() async -> Result<RMAllEpisodes, ListError> {
        do {
            let response: Result<RMAllEpisodes, ListError> = try await baseNetworkList.fetchInitial(endPoint: .episode)
            
            return response
            
        } catch {
            debugPrint("Exception: \(error)")
            return .failure(.failed)
        }
    }
    
    func fetchAdditionalEpisodes() async -> Result<RMAllEpisodes, ListError> {
        do {
            let response: Result<RMAllEpisodes, ListError> = try await baseNetworkList.fetchAdditional()
            return response
        } catch {
            debugPrint("Error \(error)")
            return .failure(.failed)
        }
    }
}
