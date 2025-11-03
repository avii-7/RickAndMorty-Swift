//
//  LocationDetailView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 03/11/25.
//

import SwiftUI

struct LocationDetailView: View {
    
    @State var viewModel: LocationDetailViewModel
    
    private let columns = Array(repeating: GridItem(.flexible(), alignment: .top), count: 2)
    
    var body: some View {
        content
            .background(.black)
            .toolbarRole(.editor)
            .navigationTitle(viewModel.location.name)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.residents.isEmpty {
                    await viewModel.fetchResidents()
                }
            }
    }
    
    private var content: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack {
                    info
                    
                    residents(size: proxy.size)
                }
                .padding(.horizontal, 16)
            }
        }
    }

    private var info: some View {
        VStack(spacing: 10) {
            ForEach(LocationInfoType.allCases) { location in
                HStack {
                    Text("\(location.rawValue): ")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(location.getValue(from: viewModel.location))
                        .lineLimit(1)
                }
                .padding(20)
                .clipShape(.rect(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white.opacity(0.5), lineWidth: 0.5)
                }
            }
        }
    }
    
    @ViewBuilder
    private func residents(size: CGSize) -> some View {
        if viewModel.viewState.isLoading {
            loader
        }
        else {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(viewModel.residents.enumerated()), id: \.element.id) { index, resident in
                    CharacterItemView(character: resident, parentSize: size)
                        .onTapGesture {
                            viewModel.didTap(resident)
                        }
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
    
    private var loader: some View {
        Image(systemName: "ellipsis")
            .resizable()
            .scaledToFit()
            .frame(height: 10)
            .symbolEffect(
                .variableColor.dimInactiveLayers.iterative,
                options: .repeat(.max).speed(1.2)
            )
            .clipped()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 25)
    }
}

#Preview {
    LocationDetailView(
        viewModel: LocationDetailViewModel(
            location: .init(
                id: .zero,
                name: "Jasmin",
                type: "Planet",
                dimension: "Unknown",
                residents: [],
                url: .empty,
                created: Date.now.description
            ),
            source: MockLocationsSource(),
            action: .init(
                didTapResident: { _ in }
            )
        )
    )
    .preferredColorScheme(.dark)
}

@Observable @MainActor
final class LocationDetailViewModel {
    
    @ObservationIgnored
    let location: RMLocation
    
    var residents: [RMCharacter] = []
    
    var viewState: ViewState = .idle
    
    @ObservationIgnored
    private let action: Action
    
    @ObservationIgnored
    private let source: LocationsSource
    
    init(location: RMLocation, source: LocationsSource, action: Action) {
        self.location = location
        self.source = source
        self.action = action
    }
    
    func fetchResidents() async {
        
        if viewState.isLoading {
            return
        }
        
        viewState = .loading
        
        do {
            try await withThrowingTaskGroup(of: RMCharacter.self) { group in
                for url in location.residents {
                    
                    group.addTask {
                        try await self.source.fetchResidents(urlString: url)
                    }
                }
                
                for try await episode in group {
                    self.residents.append(episode)
                }
            }
            
            viewState = .loaded
        }
        catch {
            printError(error)
            viewState = .error
        }
    }
    
    func didTap(_ resident: RMCharacter) {
        action.didTapResident(resident)
    }
}

extension LocationDetailViewModel {
    
    struct Action {
        let didTapResident: (RMCharacter) -> Void
    }
}
