//
//  LocationsSource.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//

import Networking

protocol LocationsSource: Sendable {
    
    func fetchLocations(pageNo: Int?) async throws -> RMAllLocations
    
    func fetchResidents(urlString: String) async throws -> RMCharacter
}

struct DefaultLocationsSource: LocationsSource {
    
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func fetchLocations(pageNo: Int?) async throws -> RMAllLocations {
        let request = LocationsHTTPRequest.locations(pageNo: pageNo)
        let response: RMAllLocations = try await httpClient.execute(httpRequest: request)
        return response
    }
    
    func fetchResidents(urlString: String) async throws -> RMCharacter {
        let request = LocationsHTTPRequest.residents(url: urlString)
        let response: RMCharacter = try await httpClient.execute(httpRequest: request)
        return response
    }
}

struct MockLocationsSource: LocationsSource {
    
    func fetchLocations(pageNo: Int?) async throws -> RMAllLocations {
        RMAllLocations(
            info: .init(
                count: 10,
                pages: 1,
                next: .empty,
                prev: .empty
            ),
            results: [.default, .default]
        )
    }
    
    func fetchResidents(urlString: String) async throws -> RMCharacter {
        .getDefault(index: 0)
    }
}
