//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import Foundation

struct RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    private var locationInfo: [RMAllLocations] = []
    
    init() {}
    
    func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMAllLocations.self) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
}
