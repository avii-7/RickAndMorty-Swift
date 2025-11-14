//
//  SearchCoordinatorView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 14/11/25.
//

import SwiftUI

struct SearchCoordinatorView: View {
    
    @State private var coordinator = SearchCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.rootView
                .navigationDestination(for: SearchCoordinator.NavigationRoute.self) { route in
                    coordinator.build(page: route)
                }
        }
        .tint(.white)
    }
}
