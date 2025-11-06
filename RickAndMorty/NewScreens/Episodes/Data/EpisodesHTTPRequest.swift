//
//  EpisodesHTTPRequest.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 04/11/25.
//

import Networking
import Foundation

enum EpisodesHTTPRequest {
    case allEpisodes(pageNo: Int? = nil), character(url: String)
}

extension EpisodesHTTPRequest: HTTPRequest {
    
    var endPoint: String {
        switch self {
        case .allEpisodes: "/episode"
        case .character(let url): NetworkUtils.removeBaseUrl(from: url)
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .allEpisodes(let pageNo): .create(args: ("page", pageNo))
        default: nil
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
}
