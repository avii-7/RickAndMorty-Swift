//
//  LocationsHTTPRequest.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 31/10/25.
//

import Foundation
import Networking

enum LocationsHTTPRequest {
    case locations(pageNo: Int? = nil), residents(url: String)
}

extension LocationsHTTPRequest: HTTPRequest {
    
    var endPoint: String {
        switch self {
        case .locations: "/location"
        case .residents(let url): NetworkUtils.removeBaseUrl(from: url)
        }
    }
    
    var queryParams: [URLQueryItem]? {
        switch self {
        case .locations(let pageNo): .create(args: ("page", pageNo))
        default: nil
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var baseURL: URL {
        URL(string: NetworkConstants.baseUrl)!
    }
}
