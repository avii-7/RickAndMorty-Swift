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
    ///  Why we can't use let here ?
    private(set) var endpoint: RMEndpoint
    
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
    
    /// Designated initializer for construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters.
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL) {
        let urlString = url.absoluteString
        
        if !urlString.contains(Constants.baseUrl) {
            print("\(urlString) does not contains \(Constants.baseUrl)")
            return nil
        }
        
        let trimmedString = urlString.replacingOccurrences(of: "\(Constants.baseUrl + Constants.pathSeprator)", with: String.empty)
        
        
        if trimmedString.contains(Constants.pathSeprator) {
            var components = trimmedString.components(separatedBy: Constants.pathSeprator)
            guard !components.isEmpty else { return nil }
            let endPointString = components.first!
            
            guard let rmEndPoint = RMEndpoint(rawValue: endPointString) else { return nil }

            if components.count > 1 {
                components.removeFirst()
            }
            
            self.init(endpoint: rmEndPoint, pathComponents: components)
        }
        else if trimmedString.contains("?") {
            let components = trimmedString.components(separatedBy: "?")
            guard !components.isEmpty else { return nil }
            let endPointString = components.first!
            guard let rmEndPoint = RMEndpoint(rawValue: endPointString) else { return nil }
            
            var queryParameters: [URLQueryItem] = []
            
            if components.count > 1 {
                let queryParametersStringArray = components[1].components(separatedBy: "&")
                
                if !queryParametersStringArray.isEmpty {
                    let _queryParameters: [URLQueryItem] = queryParametersStringArray.compactMap {
                        let keyValue = $0.components(separatedBy: "=")
                        guard !keyValue.isEmpty, keyValue.count > 1
                        else { return nil }
                        return URLQueryItem(name: keyValue[0], value: keyValue[1])
                    }
                    queryParameters.append(contentsOf: _queryParameters)
                }
            }
            
            self.init(endpoint: rmEndPoint, queryParameters: queryParameters)
        }
        else {
            return nil
        }
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
    static let listEpisodesRequest = RMRequest(endpoint: .episode)
}
