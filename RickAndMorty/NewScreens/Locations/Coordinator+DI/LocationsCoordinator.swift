//
//  LocationsCoordinator.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//
import SwiftUI

@Observable @MainActor
final class LocationsCoordinator {
    
    enum NavigationRoute {
        case locationDetails(location: RMLocation)
        case characterDetails(character: RMCharacter)
    }
    
    var navigationPath = [NavigationRoute]()
    
    @ObservationIgnored
    private let diContainer: LocationsDIContainer
    
    var rootView: some View {
        LocationListView(
            viewModel: LocationListViewModel(
                source: diContainer.locationsSource(),
                action: .init(didTapLocaton: goToDetails)
            )
        )
    }
    
    init(diContainer: LocationsDIContainer) {
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
                    action: .init(didTapResident: didTapResident)
                )
            )
        case .characterDetails(let character):
            CharacterDetailView(
                viewModel: CharacterDetailViewModel(
                    character: character,
                    source: diContainer.characterListSource()
                )
            )
        }
    }
    
    private func didTapResident(character: RMCharacter) {
        navigationPath.append(.characterDetails(character: character))
    }
}

extension LocationsCoordinator.NavigationRoute: Hashable {
    
    static func == (lhs: LocationsCoordinator.NavigationRoute, rhs: LocationsCoordinator.NavigationRoute) -> Bool {
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
