//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import Foundation

protocol RMEpisodeDataRenderer {
    var id: Int { get }
    var name: String { get }
    var episode: String { get }
    var air_date: String { get }
}

final class RMEpisodeCollectionViewCellViewModel {
    private(set) var episodeUrl: URL
    private var isDataAlreadyFetched = false
    private var dataBlock: ((RMEpisodeDataRenderer) -> Void)?
    
    private(set) var episode: RMEpisode? 
    
    // MARK: - Init
    init(episodeUrl: URL) {
        self.episodeUrl = episodeUrl
    }
    
    // MARK: -  function
     func registerForData(_ block: @escaping (RMEpisodeDataRenderer) -> Void) {
        self.dataBlock = block
    }
    
    func fetchEpisode() {
        if isDataAlreadyFetched {
            guard let episode else { return }
            dataBlock?(episode)
            return
        }
        
        Task { @MainActor [weak self, episodeUrl] in
            
            do {
                let episodeURLRequest = URLRequest(url: episodeUrl)
                
                let response: Result<RMEpisode, NetworkError> = try await NetworkRequest.shared.hit(using: episodeURLRequest)
                
                guard let self else { return }
                
                switch response {
                case .success(let model):
                    self.isDataAlreadyFetched = true
                    self.episode = model
                    self.dataBlock?(model)
                case .failure(let error):
                    print(String(describing: error))
                }
            }
            catch {
                debugPrint("Error \(error.localizedDescription)")
            }
        }
    }
}
