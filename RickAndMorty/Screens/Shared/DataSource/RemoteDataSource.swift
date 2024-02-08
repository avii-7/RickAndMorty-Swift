//
//  ListDataRepository.swift
//  RickAndMorty
//
//  Created by Arun on 06/02/24.
//

import Foundation

class RemoteDataSource : RemoteListSource {

    func fetch<T>(endPoint: RMNetworkEndpoint) async throws -> Result<T, NetworkError> where T : Decodable {
        
        guard let urlRequest = endPoint.urlRequest else {
            return .failure(.invalidURL)
        }
        
        let response: Result<T, NetworkError> = try await NetworkRequest.shared.hit(using: urlRequest)
        return response
    }
    
    func fetchAdditional<T>(using urlString: String) async throws -> Result<T, NetworkError> where T : Decodable {
        
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }
        
        let urlRequest = URLRequest(url: url)
        let response: Result<T, NetworkError> = try await NetworkRequest.shared.hit(using: urlRequest)
        
        return response
    }
}
