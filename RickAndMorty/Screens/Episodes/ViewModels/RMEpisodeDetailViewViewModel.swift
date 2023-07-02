//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

final class RMEpisodeDetailViewViewModel {
    
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
   // MARK: - Public function
    public func fetchEpisodes() {
        guard let url,
        let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print(String(describing: success))
            case .failure:
                break
            }
        }
    }
}

