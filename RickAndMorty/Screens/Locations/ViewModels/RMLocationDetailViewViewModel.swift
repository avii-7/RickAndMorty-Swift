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
        
        var residents = [RMCharacter]()
        let group = DispatchGroup()
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self ) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let character):
                    residents.append(character)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.residents =  residents
        }
    }
}

