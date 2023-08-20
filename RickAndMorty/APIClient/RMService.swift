//
//  Service.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import Foundation


/// Primary API service object to get Rick and Morty data
final class RMService {
    
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
     func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            if let cachedResponse = cacheManager.getCacheResponse(
                endPoint: request.endpoint,
                for: request.url) {
                do{
                    let result = try JSONDecoder().decode(type.self, from: cachedResponse)
                    print("Using cached response for url: \(request.url?.absoluteString ?? "")")
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                return
            }
            
            guard let urlRequest = self.getURLRequest(from: request) else {
                completion(.failure(ServiceError.failedToCreateRequest))
                return
            }

            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard let data ,error == nil else {
                    completion(.failure(ServiceError.failedToGetData))
                    return
                }
                
                // decode response
                do{
                    let result = try JSONDecoder().decode(type.self, from: data)
                    if let url = request.url {
                        self?.cacheManager.setCacheResponse(endPoint: request.endpoint, url: url, data: data)
                    }
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    // Mark: - Private
    private func getURLRequest(from request: RMRequest) -> URLRequest? {
        guard let url = request.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = request.httpMethod
        return request
    }
}
