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
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetechEpisodeDetails()
        }
    }
    
    private(set) var cellViewModels = [SectionType]()
    
    func character(at index: Int) -> RMCharacter? {
        guard let dataTuple else { return nil }
        let character = dataTuple.characters[index]
        return character
    }
    
    // MARK: - Init
    
    init(url: URL?) {
        self.url = url
    }
    
    // MARK: - Public functions
    
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
    
    // MARK: - Private functions
    
    private func createCellViewModels() {
        guard let dataTuple else { return }
        
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        let formattedDate = RMDateFormatter.getFormattedDate(for: episode.created)
        
        cellViewModels = [
            .information(viewModel:[
                .init(title: "Name", value: episode.name),
                .init(title: "Air date", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: formattedDate)
            ]),
            .characters(viewModel: characters.compactMap({
                RMCharacterCollectionViewCellViewModel(
                    id: $0.id,
                    name: $0.name,
                    status: $0.status,
                    imageUrlString: $0.image
                )
            }))
        ]
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

