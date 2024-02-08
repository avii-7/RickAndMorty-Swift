//
//  RMLocationHelper.swift
//  RickAndMorty
//
//  Created by Arun on 08/02/24.
//

import Foundation

struct RMLocationHelper {
    
    static func createCellViewModels(from locations: [RMLocation]) -> [RMLocationCellViewViewModel] {
        
        var cellViewModels = [RMLocationCellViewViewModel]()
        
        locations.forEach { location in
            let cellViewModel = RMLocationCellViewViewModel(location: location)
            cellViewModels.append(cellViewModel)
        }
        
        return cellViewModels
    }
}
