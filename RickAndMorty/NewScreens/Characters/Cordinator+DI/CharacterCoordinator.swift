//
//  CharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 30/10/25.
//

import SwiftUI

@Observable @MainActor
final class CharacterCoordinator {
    
    enum NavigationRoute {
        case characterDetails(character: RMCharacter)
    }
    
    var navigationPath = [NavigationRoute]()
    
    @ObservationIgnored
    private let diContainer: CharacterDIContainer
    
    var rootView: some View {
        CharacterListView(
            viewModel: CharacterListViewModel(
                listSource: diContainer.characterListSource(),
                action: .init(
                    didTapCharacter: goToDetails(character:)
                )
            )
        )
    }
    
    init(diContainer: CharacterDIContainer) {
        self.diContainer = diContainer
    }

    func goToDetails(character: RMCharacter) {
        navigationPath.append(.characterDetails(character: character))
    }
    
    @ViewBuilder
    func build(page: NavigationRoute) -> some View {
        switch page {
        case .characterDetails(let character):
            CharacterDetailView(
                viewModel: CharacterDetailViewModel(
                    character: character,
                    source: diContainer.characterListSource()
                )
            )
        }
    }
}

extension CharacterCoordinator.NavigationRoute: Hashable {
    
    static func == (lhs: CharacterCoordinator.NavigationRoute, rhs: CharacterCoordinator.NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.characterDetails, .characterDetails): true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
