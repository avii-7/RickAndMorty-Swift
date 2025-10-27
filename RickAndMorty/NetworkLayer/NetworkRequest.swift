//
//  NetworkHandler.swift
//  RickAndMorty
//
//  Created by Arun on 20/01/24.
//

import Foundation
import Networking

extension URLQueryItem {
    
    static func create(key: String, value: String?) -> Self? {
        
        if let value, value.isEmpty == false {
            return Self(name: key, value: value)
        }
        
        return nil
    }
    
    static func create(key: String, value: Int?) -> Self? {
        
        if let value {
            return Self(name: key, value: String(value))
        }
        
        return nil
    }
}

extension Array<URLQueryItem> {
    
    static func create(args: (key: String, value: String?)...) -> Self {
        let queryItems: [Element] = args.compactMap(Element.create(key:value:))
        return queryItems
    }
    
    static func create(args: (key: String, value: Int?)...) -> Self {
        let queryItems: [Element] = args.compactMap(Element.create(key:value:))
        return queryItems
    }
}

struct NetworkConstants {
    static let baseUrl = "https://rickandmortyapi.com/api"
}

enum NetworkEndpoint {
    case characters(pageNo: Int? = nil), location, episodes
}

extension NetworkEndpoint: HTTPRequest {
    
    var endPoint: String {
        switch self {
        case .characters: "/character"
        case .location: "/location"
        case .episodes: "/episode"
        
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .characters(let pageNo): .create(args: ("page", pageNo))
        case .location: nil
        case .episodes: nil
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var baseURL: URL {
        URL(string: NetworkConstants.baseUrl)!
    }
}

enum RMNetworkEndpoint: String {
    case character, location, episode
    
    var urlString: String {
        "\(NetworkConstants.baseUrl)/\(rawValue)"
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
        let (data, urlResponse) = try await hit(using: urlRequest)
        
        guard let httpResponse = (urlResponse as? HTTPURLResponse),
              200...299 ~= httpResponse.statusCode else {
            return .failure(NetworkError.statusCodeError)
        }
        
        let response =  try JSONDecoder().decode(T.self, from: data)
        return .success(response)
    }
    
    func hit(using urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await URLSession.shared.data(for: urlRequest)
    }
}
