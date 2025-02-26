//
//  ListRepository.swift
//  RickAndMorty
//
//  Created by Arun on 06/02/24.
//

import Foundation

protocol RemoteListSource: Sendable {
    
    func fetch<T: Decodable>(endPoint: RMNetworkEndpoint) async throws -> Result<T, NetworkError>
    
    func fetchAdditional<T: Decodable>(using urlString: String) async throws -> Result<T, NetworkError>
}
