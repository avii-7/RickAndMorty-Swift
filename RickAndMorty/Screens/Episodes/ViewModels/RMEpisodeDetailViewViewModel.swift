//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

enum EpisodeError: Error {
    case badInitialization(description: String = "episode is not initialized")
}

enum SectionType {
    case information(viewModel: [RMBasicModel])
    case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
}

final class RMEpisodeDetailViewViewModel {
    
    private var url: URL?
    
    private var episode: RMEpisode?
    
    private(set) var sections = [SectionType]()
    
    private var characters = [RMCharacter]()
    
    private(set) var isEpisodeInitialized = false
    
    func character(at index: Int) -> RMCharacter? {
        
        if characters.isEmpty {
            return nil
        }
        
        let character = characters[index]
        return character
    }
    
    // MARK: - Init
    // Must call fetch Episode method.
    init(url: URL) {
        self.url = url
    }
    
    init(episode: RMEpisode) {
        self.episode = episode
        isEpisodeInitialized = true
    }
    
    // MARK: -  functions
    func setEpisode() async throws {
        
        guard let url else {
            throw URLError(.badURL)
        }
        
        let urlRequest = URLRequest(url: url)
        
        let response: Result<RMEpisode, NetworkError> = try await NetworkRequest.shared.hit(using: urlRequest)
        
        switch response {
        case .success(let episode):
            self.episode = episode
            isEpisodeInitialized = true
        case .failure(let failure):
            throw failure
        }
    }
    
    func fetchRelatedCharacters() async throws {
        
        if characters.isEmpty == false {
            characters.removeAll()
        }
        
        guard let episode else {
            throw EpisodeError.badInitialization()
        }
        
        let requests: [URLRequest] = episode.characters.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return URLRequest(url: url)
        }
        
        if requests.isEmpty {
            return
        }
        
        let result: [RMCharacter] = try await withThrowingTaskGroup(of: (RMCharacter.self)) { group in
            
            for request in requests {
                
                group.addTask {
                    let response: Result<RMCharacter, NetworkError> = try await NetworkRequest.shared.hit(using: request)
                    switch response {
                    case .success(let character):
                        return character
                    case .failure(let error):
                        throw error
                    }
                }
            }
            
            var relatedCharacters = [RMCharacter]()
            
            for try await character in group {
                relatedCharacters.append(character)
            }
            
            return relatedCharacters
        }
        characters.append(contentsOf: result)
    }
    
    func createSections() throws {
    
        guard let episode else {
            throw EpisodeError.badInitialization()
        }
        
        if sections.isEmpty == false {
            sections.removeAll()
        }
        
        let result = RMEpisodeHelper.createCellViewModels(from: (episode, characters))
        sections.append(contentsOf: result)
    }
}
