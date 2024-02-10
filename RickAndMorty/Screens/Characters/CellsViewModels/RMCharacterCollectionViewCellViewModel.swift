//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 07/06/23.
//

import Foundation

struct RMCharacterCollectionViewCellViewModel {
    let id: Int
    let name: String
    
    private let imageUrlString: String
    
    var imageUrl: URL? {
        URL(string: imageUrlString)
    }
    
    private let status: RMCharacterStatus
    
    var statusText: String {
        "Status: \(status.text)"
    }
    
    // MARK: - Init
    init(id: Int ,name: String, status: RMCharacterStatus, imageUrlString: String) {
        self.id = id
        self.name = name
        self.status = status
        self.imageUrlString = imageUrlString
    }
    
    func fetchImage() async throws -> Result<Data, NetworkError> {
        
        guard let imageUrl = URL(string: imageUrlString) else {
            return .failure(.invalidURL)
        }
        
        let response = try await RMImageManager.shared.downloadImage(from: imageUrl)
        return response
    }
}
