//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Arun on 20/01/24.
//

import Foundation

struct NetworkConstants {
    static let baseUrl = "https://rickandmortyapi.com/api"
    static let pathSeprator = "/"
}

enum RMNetworkEndpoint: String {
    case character, location, episode
    
    var urlString: String {
        "\(NetworkConstants.baseUrl)\(NetworkConstants.pathSeprator)\(rawValue)"
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return URLRequest(url: url)
    }
}

enum NetworkError: Error {
    case statusCodeError, invalidURL
}

struct NetworkRequest {
    
    private init() {}
    
    static let shared = NetworkRequest()
    
    func hit<T>(using urlRequest: URLRequest) async throws -> Result<T, NetworkError> where T: Decodable {
        let (data, urlResponse) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = (urlResponse as? HTTPURLResponse),
              200...299 ~= httpResponse.statusCode else {
            return .failure(NetworkError.statusCodeError)
        }
        
        let response =  try JSONDecoder().decode(T.self, from: data)
        return .success(response)
    }
}
