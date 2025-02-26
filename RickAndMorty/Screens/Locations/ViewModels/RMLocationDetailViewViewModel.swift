//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 19/07/23.
//

import Foundation

enum RMLocationDetailSection {
    case information(viewModel: [RMBasicModel])
    case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
}

final class RMLocationDetailViewViewModel: Sendable {
    
    let location: RMLocation

    // MARK: - Init
    init(location: RMLocation) {
        self.location = location
    }
    
    func getResidents() async throws -> [RMCharacter] {
        
        let requests: [URLRequest] = location.residents.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return URLRequest(url: url)
        }
        
        let residents: [RMCharacter] = try await withThrowingTaskGroup(of: (RMCharacter.self)) { group in
            
            for request in requests {
                
                group.addTask {
                    let response: Result<RMCharacter, NetworkError> = try await NetworkRequest.shared.hit(using: request)
                    switch response {
                    case .success(let resident):
                        return resident
                    case .failure(let error):
                        throw error
                    }
                }
            }
            
            var residents = [RMCharacter]()
            
            for try await resident in group {
                residents.append(resident)
            }
            
            return residents
        }
        return residents
    }
}

