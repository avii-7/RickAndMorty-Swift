//
//  EpisodesCoordinatorView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 06/11/25.
//

import SwiftUI

struct EpisodesCoordinatorView: View {
    
    @State private var coordinator = EpisodesCoordinator(diContainer: EpisodesDIContainer())
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.rootView
                .navigationDestination(for: EpisodesCoordinator.NavigationRoute.self) { route in
                    coordinator.build(page: route)
                }
        }
        .tint(.white)
    }
}
