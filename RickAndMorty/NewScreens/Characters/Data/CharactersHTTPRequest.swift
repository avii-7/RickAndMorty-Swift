//
//  CharactersHTTPRequest.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//

import Networking
import Foundation

enum CharactersHTTPRequest {
    case characters(pageNo: Int? = nil), episode(url: String)
}

extension CharactersHTTPRequest: HTTPRequest {
    
    var endPoint: String {
        switch self {
        case .characters: "/character"
        case .episode(let url): NetworkUtils.removeBaseUrl(from: url)
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .characters(let pageNo): .create(args: ("page", pageNo))
        default: nil
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
