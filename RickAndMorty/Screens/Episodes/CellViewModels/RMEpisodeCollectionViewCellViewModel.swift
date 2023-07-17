//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

protocol RMEpisodeDataRenderer {
    var name: String { get }
    var episode: String { get }
    var air_date: String { get }
}

final class RMEpisodeCollectionViewCellViewModel {
    private(set) var episodeUrl: URL?
    private var isDataAlreadyFetched = false
    private var dataBlock: ((RMEpisodeDataRenderer) -> Void)?
    let borderColor: UIColor
    
    private var episode: RMEpisode? {
        didSet {
            guard let episode else { return }
            dataBlock?(episode)
        }
    }
    
    // MARK: - Init
    
    init(episodeUrl: URL?, borderColor: UIColor = .blue) {
        self.episodeUrl = episodeUrl
        self.borderColor = borderColor
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

        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let model):
                self.isDataAlreadyFetched = true
                DispatchQueue.main.async {
                    self.episode = model
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

extension RMEpisodeCollectionViewCellViewModel : Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeUrl)
    }
    
    static func == (lhs: RMEpisodeCollectionViewCellViewModel, rhs: RMEpisodeCollectionViewCellViewModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}