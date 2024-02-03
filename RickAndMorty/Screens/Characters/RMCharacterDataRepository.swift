//
//  CharacterDataRepository.swift
//  RickAndMorty
//
//  Created by Arun on 22/01/24.
//

import Foundation

final class RMCharacterDataRepository {
    
    private let baseNetworkList = BaseNetworkListRepository()
    
    func fetchInitialCharacters() async -> Result<RMAllCharacters, ListError> {
        do {
            let response: Result<RMAllCharacters, ListError> = try await baseNetworkList.fetchInitial(endPoint: .character)
            
            return response
            
        } catch {
            debugPrint("Exception: \(error)")
            return .failure(.failed)
        }
    }
    
    func fetchAdditionalCharacters() async -> Result<RMAllCharacters, ListError> {
        do {
            let response: Result<RMAllCharacters, ListError> = try await baseNetworkList.fetchAdditional()
            return response
        } catch {
            debugPrint("Error \(error)")
            return .failure(.failed)
        }
    }
}
