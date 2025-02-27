//
//  Service.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import Foundation


/// Primary API service object to get Rick and Morty data
final class RMService: Sendable {
    
    /// Privatized constructor
    private init() {}
    
    /// Shared singleton instance
    static let shared = RMService()
    
    private let cacheManager = RMAPICacheManager()
    
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instace
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    ///
    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type) async -> Result<T, Error> {
            
            do {
                if let cachedResponse = await cacheManager.getCacheResponse(
                    endPoint: request.endpoint,
                    for: request.url) {
                    
                    let result = try JSONDecoder().decode(type.self, from: cachedResponse)
                    return .success(result)
                }
                
                guard let urlRequest = self.getURLRequest(from: request) else {
                    return .failure(ServiceError.failedToCreateRequest)
                }
                
                let (data, _) = try await URLSession.shared.data(for: urlRequest)
                
                let result = try JSONDecoder().decode(type.self, from: data)
                
                if let url = request.url {
                    await cacheManager.setCacheResponse(
                        endPoint: request.endpoint,
                        url: url,
                        data: data
                    )
                }
                
                return .success(result)
            } catch {
                return .failure(ServiceError.failedToGetData)
            }
        }
    
    // Mark: - Private
    private func getURLRequest(from request: RMRequest) -> URLRequest? {
        guard let url = request.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
