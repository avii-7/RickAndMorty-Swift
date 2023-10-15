//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

final class RMEpisodeDetailViewViewModel {
    
    enum SectionType {
        case information(viewModel: [RMBasicModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    private let url: URL?
    
    weak var delegate: RMNetworkDelegate?
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchData()
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
    
    // MARK: -  functions
    
    func fetchEpisodes() {
        
        guard
            let url,
            let request = RMRequest(url: url) else { return }
        
        Task {
            let response = await RMService.shared.execute(request, expecting: RMEpisode.self)
            switch response {
            case .success(let model):
                await fetchRelatedCharacters(episode: model)
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
    
    private func fetchRelatedCharacters(episode: RMEpisode) async {
        
        let requests: [RMRequest] = episode.characters.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return RMRequest(url: url)
        }

        do {
            var relatedCharacters = [RMCharacter]()
            
            try await withThrowingTaskGroup(of: (RMCharacter.self)) { group in
                
                for request in requests {
                    group.addTask {
                        let response = await RMService.shared.execute(
                            request,
                            expecting: RMCharacter.self
                        )
                        switch response {
                        case .success(let character):
                            return character
                        case .failure:
                            return .getDefault()
                        }
                    }
                }
                
                for try await character in group {
                    relatedCharacters.append(character)
                }
            }
            
            DispatchQueue.main.async {
                self.dataTuple = (episode, relatedCharacters)
            }
        }
        catch {
            debugPrint(error)
        }
    }
}
