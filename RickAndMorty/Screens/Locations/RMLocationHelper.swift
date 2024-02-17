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
    
    static func getSections(location: RMLocation, residents: [RMCharacter]) -> [RMLocationDetailSection] {
        
        let formattedDate = RMDateFormatter.getFormattedDate(for: location.created)
        
        let sections: [RMLocationDetailSection] = [
            .information(viewModel:[
                .init(title: "Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: formattedDate)
            ]),
            .characters(viewModel: residents.compactMap({
                RMCharacterCollectionViewCellViewModel(
                    id: $0.id,
                    name: $0.name,
                    status: $0.status,
                    imageUrlString: $0.image
                )
            }))
        ]
        
        return sections
    }
}
