//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 19/07/23.
//

import Foundation

final class RMLocationDetailViewViewModel {
    
    enum SectionType {
        case information(viewModel: [RMBasicModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    private let location: RMLocation
    
    weak var delegate: RMNetworkDelegate?
    
    private var residents: [RMCharacter]? {
        didSet {
            createCellViewModels()
            delegate?.didFetchData()
        }
    }
    
    private(set) var cellViewModels = [SectionType]()
    
    func character(at index: Int) -> RMCharacter? {
        guard let residents else { return nil }
        let character = residents[index]
        return character
    }
    
    // MARK: - Init
    
    init(location: RMLocation) {
        self.location = location
    }
    
    // MARK: - Private functions
    
    private func createCellViewModels() {
        guard let residents else { return }
        
        let formattedDate = RMDateFormatter.getFormattedDate(for: location.created)
        
        cellViewModels = [
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
    }
    
    func fetchResidents() {
        
        let requests: [RMRequest] = location.residents.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return RMRequest(url: url)
        }
        
        Task {
            try await withThrowingTaskGroup(of: RMCharacter.self) { group in
                
                var residents = [RMCharacter]()
                
                for request in requests {
                    
                    group.addTask {
                        let response = await RMService.shared.execute(request, expecting: RMCharacter.self )
                        
                        switch response {
                        case .success(let character):
                            return character
                        case .failure:
                            return .getDefault()
                        }
                    }
                    
                    for try await character in group {
                        residents.append(character)
                    }
                }
                
                self.residents = residents
            }
        }
    }
}

