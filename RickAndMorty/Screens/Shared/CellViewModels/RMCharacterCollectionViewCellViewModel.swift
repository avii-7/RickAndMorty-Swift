//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 07/06/23.
//

import Foundation

struct RMCharacterCollectionViewCellViewModel {
    public let id: Int
    public let name: String
    
    private let imageUrlString: String
    public var imageUrl: URL? {
        URL(string: imageUrlString)
    }
    
    private let status: RMCharacterStatus
    
    public var statusText: String {
        "Status: \(status.text)"
    }
    
    // MARK: - Init
    
    init(id: Int ,name: String, status: RMCharacterStatus, imageUrlString: String) {
        self.id = id
        self.name = name
        self.status = status
        self.imageUrlString = imageUrlString
    }
    
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(from: url, completion: completion)
    }
}
