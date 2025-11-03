//
//  LocationListView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 31/10/25.
//

import SwiftUI

struct LocationListView: View {
    
    @State var viewModel: LocationListViewModel
    
    var body: some View {
        content
            .navigationTitle("Locations")
            .background(.black)
            .task {
                if viewModel.locations.isEmpty {
                    await viewModel.fetchLocations()
                }
            }
    }
    
    private var content: some View {
        List {
            ForEach(Array(viewModel.locations.enumerated()), id: \.offset) { index, location in
                
                Group {
                    if index == viewModel.locations.endIndex - 1 {
                        getView(location)
                            .onAppear {
                                viewModel.fetchNextPageLocations()
                            }
                    }
                    else {
                        getView(location)
                    }
                }
                .onTapGesture {
                    viewModel.didTapLocation(location)
                }
            }

            if viewModel.hasMore {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
    private func getView(_ location: RMLocation) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .foregroundStyle(.white)
                .font(.title3)
            
            Text("Type: \(location.type)")
                .foregroundStyle(.white.secondary)
                .font(.subheadline)
            
            Text("Dimension: \(location.dimension)")
                .foregroundStyle(.white)
                .font(.body)
                .foregroundStyle(.white.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
    }
}

@Observable @MainActor
final class LocationListViewModel {
    
    var locations: [RMLocation] = []
    
    var viewState = ViewState.idle
    
    var paginationState: ViewState = .idle
    
    @ObservationIgnored
    var pageInfo: RMInfo? = nil
    
    @ObservationIgnored
    var hasMore: Bool { pageInfo?.next != nil }
    
    @ObservationIgnored
    var nextPage: Int = 1
    
    @ObservationIgnored nonisolated
    let source: LocationsSource
    
    @ObservationIgnored
    let action: Action
    
    init(source: LocationsSource, action: Action) {
        self.source = source
        self.action = action
    }
    
    func fetchLocations() async {
        
        if viewState.isLoading { return }
        
        viewState = .loading
        
        do {
            let response: RMAllLocations = try await source.fetchLocations(pageNo: nextPage)
            self.locations = response.results
            self.pageInfo = response.info
            if pageInfo?.next != nil { nextPage += 1 }
            viewState = .loaded
        }
        catch {
            printError(error)
            viewState = .error
        }
    }
    
    func fetchNextPageLocations() {
        
        if paginationState.isLoading { return }
        
        paginationState = .loading
        
        Task {
            do {
                let response: RMAllLocations = try await source.fetchLocations(pageNo: nextPage)
                self.locations.append(contentsOf: response.results)
                self.pageInfo = response.info
                if pageInfo?.next != nil { nextPage += 1 }
                paginationState = .loaded
            }
            catch {
                printError(error)
                paginationState = .error
            }
        }
    }
    
    func didTapLocation(_ location: RMLocation) {
        action.didTapLocaton(location)
    }
}

extension LocationListViewModel {
    
    struct Action {
        let didTapLocaton: (RMLocation) -> Void
    }
}
