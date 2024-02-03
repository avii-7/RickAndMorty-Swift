//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Arun on 20/01/24.
//

import Foundation

enum NetworkError: Error {
    case failed
}

struct NetworkRequest {
    
    func hit<T>(using urlRequest: URLRequest) async throws -> Result<T, NetworkError> where T: Decodable {
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = (urlResponse as? HTTPURLResponse),
              200...299 ~= httpResponse.statusCode else {
            return .failure(NetworkError.failed)
        }
        
        let response =  try JSONDecoder().decode(T.self, from: data)
        return .success(response)
    }
}
