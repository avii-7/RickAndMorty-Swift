//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import Foundation

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didLoadInitialLocations()
    func didLoadMoreLocations(at indexPaths: [IndexPath])
}

final class RMLocationViewViewModel: NSObject {
    
    let listSource: RemoteListSource
    
    init(listSource: RemoteListSource) {
        self.listSource = listSource
    }
    
    func fetchInitialLocations() async throws -> Result<RMAllLocations, NetworkError> {
        let response: Result<RMAllLocations, NetworkError> = try await listSource.fetch(endPoint: .location)
        return response
    }
    
    func fetchAdditionalLocations(urlString: String) async throws -> Result<RMAllLocations, NetworkError> {
        let response: Result<RMAllLocations, NetworkError> = try await listSource.fetchAdditional(using: urlString)
        return response
    }
}
