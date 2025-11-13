//
//  SearchSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 11/11/25.
//

import Networking
import Foundation

protocol SearchSource: Sendable {
    
    func search<T: RMInfoResults>(query: String, for tab: TabbarItem) async throws -> T
}

struct DefaultSearchSource: SearchSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func search<T: RMInfoResults>(query: String, for tab: TabbarItem) async throws -> T {
        
        let request: SearchHTTPRequest = .character(query: query)
        
        // TODO: - Pending.
        guard TabbarItem.searchTabs.contains(tab) else {
            throw NSError(domain: "Invalid tab", code: .zero)
        }
        
//        switch tab {
//        case .characters:
//            request = .character(query: query)
//        case .episodes:
//            request = .episode(query: query)
//        case .locations:
//            request = .location(query: query)
//        case .settings:
//            request = .character(query: query)
//        }
        
        let response: T = try await httpClient.execute(httpRequest: request)
        return response
    }
}
