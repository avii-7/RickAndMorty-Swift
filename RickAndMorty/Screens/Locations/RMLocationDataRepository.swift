//
//  LocationDataRepository.swift
//  RickAndMorty
//
//  Created by Arun on 03/02/24.
//

import Foundation

final class RMLocationDataRepository {
    
    private let baseNetworkList = BaseNetworkListRepository()
    
    func fetchInitialLocations() async -> Result<RMAllLocations, ListError> {
        do {
            let response: Result<RMAllLocations, ListError> = try await baseNetworkList.fetchInitial(endPoint: .location)
            
            return response
            
        } catch {
            debugPrint("Exception: \(error)")
            return .failure(.failed)
        }
    }
    
    func fetchAdditionalLocations() async -> Result<RMAllLocations, ListError> {
        do {
            let response: Result<RMAllLocations, ListError> = try await baseNetworkList.fetchAdditional()
            return response
        } catch {
            debugPrint("Error \(error)")
            return .failure(.failed)
        }
    }
}
