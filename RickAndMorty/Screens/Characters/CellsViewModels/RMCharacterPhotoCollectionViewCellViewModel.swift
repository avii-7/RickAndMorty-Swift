//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL
    
    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }
    
    func fetchImage() async throws -> Result<Data, NetworkError> {
        let response = try await RMImageManager.shared.downloadImage(from: imageUrl)
        return response
    }
}
