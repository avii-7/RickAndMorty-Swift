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
    
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instace
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            guard let urlRequest = self.getURLRequest(from: request) else {
                completion(.failure(ServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                guard let data, error == nil else {
                    completion(.failure(ServiceError.failedToGetData))
                    return
                }
                
                // decode response
                do{
                    let result = try JSONDecoder().decode(type.self, from: data)
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
