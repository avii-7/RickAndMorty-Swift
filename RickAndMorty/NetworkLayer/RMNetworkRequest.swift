//
//  Request.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
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

