//
//  EpisodesCoordinator.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 04/11/25.
//

import SwiftUI

@Observable
final class EpisodesCoordinator: BaseCoordinator {
    
    enum NavigationRoute {
        case episodeDetails(episode: RMEpisode)
        case locationDetails(location: RMLocation)
        case characterDetails(character: RMCharacter)
    }
    
    var navigationPath = [NavigationRoute]()
    
    @ObservationIgnored
    let diContainer: EpisodesDIContainer
    
    var rootView: some View {
        EpisodeListView(
            viewModel: EpisodeListViewModel(
                listSource: diContainer.episodesSource(),
                action: .init(didTapEpisode: didTap(_:))
            )
        )
    }
    
    init(diContainer: EpisodesDIContainer) {
        self.diContainer = diContainer
    }

    private func goToDetails(location: RMLocation) {
        navigationPath.append(.locationDetails(location: location))
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
    
    private func didTap(_ location: RMLocation) {
        navigationPath.append(.locationDetails(location: location))
    }
    
    private func didTap(_ episode: RMEpisode) {
        navigationPath.append(.episodeDetails(episode: episode))
    }
    
    private func didTap(_ character: RMCharacter) {
        navigationPath.append(.characterDetails(character: character))
    }
}

extension EpisodesCoordinator.NavigationRoute: Hashable {
    
    static func == (lhs: EpisodesCoordinator.NavigationRoute, rhs: EpisodesCoordinator.NavigationRoute) -> Bool {
        switch (lhs, rhs) {
        case (.locationDetails, .locationDetails): true
        case (.characterDetails, .characterDetails): true
        default: false
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}
