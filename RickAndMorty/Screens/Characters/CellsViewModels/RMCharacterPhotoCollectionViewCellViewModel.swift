//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
     func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageManager.shared.downloadImage(from: imageUrl, completion: completion)
    }
}
