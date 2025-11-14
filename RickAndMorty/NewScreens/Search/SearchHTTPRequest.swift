//
//  SearchHTTPRequest.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 11/11/25.
//

import Networking
import Foundation

enum SearchHTTPRequest {
    case character(query: String, page: Int?)
    case location(query: String, page: Int?)
    case episode(query: String, page: Int?)
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
        case .character(let query, let page): .create(args: ("name", query), ("page", String(page)))
        case .location(let query, let page): .create(args: ("name", query), ("page", String(page)))
        case.episode(let query, let page): .create(args: ("name", query), ("page", String(page)))
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
