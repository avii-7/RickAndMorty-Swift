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
    
     func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(from: url, completion: completion)
    }
}

extension RMCharacterCollectionViewCellViewModel : Equatable, Hashable {
    
}
