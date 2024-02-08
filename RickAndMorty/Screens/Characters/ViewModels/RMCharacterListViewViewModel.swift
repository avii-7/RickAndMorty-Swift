//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 06/06/23.
//

import Foundation

typealias ListResult<T> = Result<[T], NetworkError>

/// View model to handle character list logic
final class RMCharacterListViewViewModel {
    
    private let listSource: RemoteListSource
    
    private var hasMoreCharacters = false
    
    init(listSource: RemoteListSource) {
        self.listSource = listSource
    }
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialCharacters() async throws -> Result<RMAllCharacters, NetworkError> {
        let response: Result<RMAllCharacters, NetworkError> = try await listSource.fetch(endPoint: .character)
        return response
    }
    
    func fetchAdditionalCharacters(urlString: String) async throws -> Result<RMAllCharacters, NetworkError> {
        let response: Result<RMAllCharacters, NetworkError> = try await listSource.fetchAdditional(using: urlString)
        return response
    }
}
