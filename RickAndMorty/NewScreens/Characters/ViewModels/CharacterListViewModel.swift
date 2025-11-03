//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 26/10/25.
//

import Foundation

@Observable @MainActor
final class CharacterListViewModel {
    
    var characters: [RMCharacter] = []
    
    var viewState = ViewState.idle
    
    var paginationState: ViewState = .idle
    
    @ObservationIgnored 
    var pageInfo: RMInfo? = nil
    
    @ObservationIgnored
    var hasMore: Bool { pageInfo?.next != nil }
    
    @ObservationIgnored
    var nextPage: Int = 1
    
    @ObservationIgnored
    private let listSource: CharactersSource

    @ObservationIgnored
    private let action: Action
    
    init(listSource: CharactersSource, action: Action) {
        self.listSource = listSource
        self.action = action
    }
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialCharacters() async {
        
        if viewState.isLoading { return }
        
        viewState = .loading
        
        do {
            let response: RMAllCharacters = try await listSource.fetchAllCharacters(pageNo: nextPage)
            self.characters = response.results
            self.pageInfo = response.info
            if pageInfo?.next != nil { nextPage += 1 }
            viewState = .loaded
        }
        catch {
            printError(error)
            viewState = .error
        }
    }
    
    func fetchNextPageCharacters() {
        
        if paginationState.isLoading { return }
        
        paginationState = .loading
        
        Task {
            do {
                let response: RMAllCharacters = try await listSource.fetchAllCharacters(pageNo: nextPage)
                self.characters.append(contentsOf: response.results)
                self.pageInfo = response.info
                if pageInfo?.next != nil { nextPage += 1 }
                paginationState = .loaded
            }
            catch {
                printError(error)
                paginationState = .error
            }
        }
    }
    
    func didTap(_ character: RMCharacter) {
        action.didTapCharacter(character)
    }
}

extension CharacterListViewModel {
    
    struct Action {
        let didTapCharacter: (RMCharacter) -> Void
    }
}
