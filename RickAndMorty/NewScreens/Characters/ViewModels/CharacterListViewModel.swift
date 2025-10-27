//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 26/10/25.
//

import Foundation

@Observable @MainActor
final class CharacterListViewModel {
    
    var characters: [RMCharacter] = []
    
    @ObservationIgnored
    var pageInfo: RMInfo? = nil
    
    @ObservationIgnored
    private let listSource: CharacterListSource
    
    @ObservationIgnored
    var hasMore: Bool { pageInfo?.next != nil }
    
    @ObservationIgnored
    var nextPage: Int = 1
    
    init(listSource: CharacterListSource) {
        self.listSource = listSource
    }
    
    /// Fetch initial set of characters ( 20 )
    func fetchInitialCharacters() async {
        do {
            let response: RMAllCharacters = try await listSource.fetchAllCharacters(pageNo: nextPage)
            self.characters = response.results
            self.pageInfo = response.info
            if pageInfo?.next != nil { nextPage += 1 }
        }
        catch {
            printError(error)
        }
    }
    
    func fetchNextPageCharacters() {
        Task {
            do {
                let response: RMAllCharacters = try await listSource.fetchAllCharacters(pageNo: nextPage)
                self.characters.append(contentsOf: response.results)
                self.pageInfo = response.info
            }
            catch {
                printError(error)
            }
        }
    }
}
