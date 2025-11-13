//
//  SearchHTTPRequest.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 11/11/25.
//

import Networking
import Foundation

enum SearchHTTPRequest {
    case character(query: String)
    case location(query: String)
    case episode(query: String)
}

extension SearchHTTPRequest: HTTPRequest {
    
    var endPoint: String {
        switch self {
        case .character: "/character"
        case .location: "/location"
        case .episode: "/episode"
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .character(let query): [.init(name: "name", value: query)]
        case .location(let query): [.init(name: "name", value: query)]
        case .episode(let query): [.init(name: "name", value: query)]
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
