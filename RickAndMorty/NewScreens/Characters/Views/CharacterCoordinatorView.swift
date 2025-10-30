//
//  CharacterCoordinatorView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 30/10/25.
//

import SwiftUI

struct CharacterCoordinatorView: View {
    
    @State private var coordinator = CharacterCoordinator(diContainer: CharacterDIContainer())
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.rootView
                .navigationDestination(for: CharacterCoordinator.NavigationRoute.self) { route in
                    switch route {
                    case .characterDetails(let character):
                        CharacterDetailView(character: character)
                    }
                }
        }
    }
}
