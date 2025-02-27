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

actor RMEpisodeDetailViewViewModel {
    
    private let url: URL?
    
    private var episode: RMEpisode?
    
    private(set) var isEpisodeInitialized = false
    
    // MARK: - Init
    // Must call fetch Episode method.
    init(url: URL) {
        self.url = url
    }
    
    init(episode: RMEpisode) {
        self.episode = episode
        isEpisodeInitialized = true
        self.url = nil
    }
    
    // MARK: - Functions
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
    
    func getRelatedCharacters() async throws -> [RMCharacter] {
        
        guard let episode else {
            throw EpisodeError.badInitialization()
        }
        
        let requests: [URLRequest] = episode.characters.compactMap {
            guard let url = URL(string: $0) else { return nil }
            return URLRequest(url: url)
        }
        
        if requests.isEmpty {
            return []
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
        return result
    }
    
    func getSections(for characters: [RMCharacter]) throws -> [SectionType] {
    
        guard let episode else {
            throw EpisodeError.badInitialization()
        }
        
        return RMEpisodeHelper.createCellViewModels(from: (episode, characters))
    }
}
