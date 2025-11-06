//
//  CharacterCoordinator.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 30/10/25.
//

import SwiftUI
import FactoryKit


@MainActor
protocol BaseCoordinator: AnyObject {
    
    associatedtype Route: Hashable
    
    associatedtype Body: View
    
    associatedtype Container: SharedContainer
    
    associatedtype NavigationRoute: Hashable
    
    var navigationPath: [Route] { get set }
    
    var rootView: Self.Body { get }
    
    var diContainer: Container { get }
}

@Observable
final class CharacterCoordinator: BaseCoordinator {
    
    enum NavigationRoute {
        case characterDetails(character: RMCharacter)
        case episodeDetails(episode: RMEpisode)
        case locationDetails(location: RMLocation)
    }

    var navigationPath: [NavigationRoute] = []

    @ObservationIgnored
    let diContainer: CharacterDIContainer
    
    var rootView: some View {
        CharacterListView(
            viewModel: CharacterListViewModel(
                listSource: diContainer.charactersSource(),
                action: .init(didTapCharacter: didTap)
            )
        )
    }
    
    init(diContainer: CharacterDIContainer) {
        self.diContainer = diContainer
    }

    @ViewBuilder
    func build(page: NavigationRoute) -> some View {
        switch page {
        case .locationDetails(let location):
            LocationDetailView(
                viewModel: LocationDetailViewModel(
                    location: location,
                    source: diContainer.locationsSource(),
                    action: .init(didTapResident: didTap)
                )
            )
            
        case .characterDetails(let character):
            CharacterDetailView(
                viewModel: CharacterDetailViewModel(
                    character: character,
                    source: diContainer.charactersSource(),
                    action: .init(didTapEpisode: didTap)
                )
            )
        case .episodeDetails(let episode):
            EpisodeDetailView(
                viewModel: EpisodeDetailViewModel(
                    episode: episode,
                    source: diContainer.episodesSource(),
                    action: .init(didTap: didTap)
                )
            )
        }
    }
    
    private func didTap(_ episode: RMEpisode) {
        navigationPath.append(.episodeDetails(episode: episode))
    }
    
    private func didTap(_ character: RMCharacter) {
        navigationPath.append(.characterDetails(character: character))
    }
}

extension CharacterCoordinator.NavigationRoute: Hashable {
    
    static func == (lhs: CharacterCoordinator.NavigationRoute, rhs: CharacterCoordinator.NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.characterDetails, .characterDetails): true
        case (.episodeDetails, .episodeDetails): true
        case (.locationDetails, .locationDetails): true
        default: false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
