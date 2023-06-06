//
//  Request.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import Foundation

/// Object that represents single API call
final class RMRequest {
    
    /// API constants
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
        static let pathSeprator = "/"
    }
    
    /// Desired Endpoint
    private let endpoint: Endpoint
    
    /// Path components for API, if any
    private let pathComponents: [String]
    
    /// Query parameters for API, if any
    private let queryParameters: [URLQueryItem]
    
    /// String format url for API request
    private var urlString: String {
        var string = Constants.baseUrl
        string += Constants.pathSeprator
        
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach ({
                string += "/\($0)"
            })
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    
    /// Computed and constructed API url
    public var url: URL? {
        URL(string: urlString)
    }
    
    /// Desired http method
    public let httpMethod = "GET"
    
    // Mark: - Public
    
    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters.
    public init(endpoint: Endpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
}