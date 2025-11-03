//
//  LocationsCoordinatorView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 31/10/25.
//

import SwiftUI

struct LocationsCoordinatorView: View {

    @State private var coordinator = LocationsCoordinator(diContainer: LocationsDIContainer())
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            coordinator.rootView
                .navigationDestination(for: LocationsCoordinator.NavigationRoute.self) { route in
                    coordinator.build(page: route)
                }
        }
        .tint(.white)
    }
}
