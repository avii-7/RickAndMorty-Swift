//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import Foundation

protocol RMEpisodeDataRenderer {
    var name: String { get }
    var episode: String { get }
    var air_date: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeUrl: URL?
    private var isDataAlreadyFetched = false
    private var dataBlock: ((RMEpisodeDataRenderer)->Void)?
    
    private var episode: RMEpisode? {
        didSet {
            guard let episode else { return }
            dataBlock?(episode)
        }
    }
    
    // MARK: - Init
    
    init(episodeUrl: URL?) {
        self.episodeUrl = episodeUrl
    }
    
    // MARK: - Public function
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRenderer) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        if isDataAlreadyFetched {
            guard let episode else { return }
            dataBlock?(episode)
            return
        }
        
        guard let episodeUrl,
              let request = RMRequest(url: episodeUrl)
        else { return }
        
        isDataAlreadyFetched = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self.episode = model
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
