//
//  SearchCoordinator.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 14/11/25.
//

import FactoryKit
import SwiftUI

@Observable
final class SearchCoordinator: BaseCoordinator {
    
    enum NavigationRoute {
        case characterDetails(character: RMCharacter)
        case episodeDetails(episode: RMEpisode)
        case locationDetails(location: RMLocation)
    }

    var navigationPath: [NavigationRoute] = []
    
    var rootView: some View {
        SearchView(
            viewModel: SearchViewModel(
                listSource: Container.shared.searchSource(),
                action: .init(
                    didTapCharacter: didTap,
                    didTapEpisode: didTap,
                    didTapLocation: didTap
                )
            )
        )
    }
    
    @ViewBuilder
    func build(page: NavigationRoute) -> some View {
        switch page {
        case .locationDetails(let location):
            LocationDetailView(
                viewModel: LocationDetailViewModel(
                    location: location,
                    source: Container.shared.locationsSource(),
                    action: .init(didTapResident: didTap)
                )
            )
            
        case .characterDetails(let character):
            CharacterDetailView(
                viewModel: CharacterDetailViewModel(
                    character: character,
                    source: Container.shared.charactersSource(),
                    action: .init(didTapEpisode: didTap)
                )
            )
        case .episodeDetails(let episode):
            EpisodeDetailView(
                viewModel: EpisodeDetailViewModel(
                    episode: episode,
                    source: Container.shared.episodesSource(),
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
    
    private func didTap(_ location: RMLocation) {
        navigationPath.append(.locationDetails(location: location))
    }
}

extension SearchCoordinator.NavigationRoute: Hashable {
    
    static func == (lhs: SearchCoordinator.NavigationRoute, rhs: SearchCoordinator.NavigationRoute) -> Bool {
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
