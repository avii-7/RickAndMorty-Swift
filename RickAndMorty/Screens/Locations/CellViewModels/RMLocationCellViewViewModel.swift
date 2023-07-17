//
//  RMLocationCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 17/07/23.
//

import Foundation

struct RMLocationCellViewViewModel {

    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    var id: Int {
        location.id
    }
    
    var name: String {
        location.name
    }
    
    var type: String {
        location.type
    }
    
    var dimension: String {
        location.dimension
    }
}
