//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    func didFetechEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    private let url: URL?
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetechEpisodeDetails()
        }
    }
    
    private(set) var sections = [SectionType]()
    
    // MARK: - Init
    
    init(url: URL?) {
        self.url = url
    }
    
    // MARK: - Public function
    
    public func fetchEpisodes() {
        guard
            let url,
            let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(episode: model)
            case .failure(_):
                break
            }
        }
    }
    
    private func fetchRelatedCharacters(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return RMRequest(url: url)
        }
        
        var relatedCharacters = [RMCharacter]()
        let group = DispatchGroup()
        
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self ) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let character):
                    relatedCharacters.append(character)
                case .failure:
                    break
                }
            }
        }
        group.notify(queue: .main) {
            self.dataTuple = (episode, relatedCharacters)
        }
    }
}

