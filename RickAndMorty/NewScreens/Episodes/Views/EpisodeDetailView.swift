//
//  EpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 04/11/25.
//

import SwiftUI

struct EpisodeDetailView: View {
    
    @State var viewModel: EpisodeDetailViewModel
    
    private let columns = Array(repeating: GridItem(.flexible(), alignment: .top), count: 2)
    
    var body: some View {
        content
            .navigationTitle(viewModel.episode.name)
            .toolbarRole(.editor)
            .background(.black)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.fetchCharacters()
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
            ForEach(EpisodeInfoType.allCases) { episode in
                HStack {
                    Text("\(episode.rawValue): ")
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(episode.getValue(from: viewModel.episode))
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
                ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                    CharacterItemView(character: character, parentSize: size)
                        .onTapGesture {
                            viewModel.didTap(character)
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

//#Preview {
//    EpisodeDetailView()
//}


@Observable @MainActor
final class EpisodeDetailViewModel {
    
    @ObservationIgnored
    let episode: RMEpisode
    
    @ObservationIgnored
    let source: EpisodesSource
    
    @ObservationIgnored
    let action: Action
    
    var characters: [RMCharacter] = []
    
    var viewState: ViewState = .idle
    
    init(episode: RMEpisode, source: EpisodesSource, action: Action) {
        self.episode = episode
        self.source = source
        self.action = action
    }
    
    func fetchCharacters() async {
        do {
            try await withThrowingTaskGroup(of: RMCharacter.self) { group in
                
                for url in episode.characters {
                    group.addTask {
                        try await self.source.fetchCharacter(using: url)
                    }
                }
                
                for try await episode in group {
                    self.characters.append(episode)
                }
            }
        }
        catch {
            printError(error)
        }
    }
    
    func didTap(_ character: RMCharacter) {
        action.didTap(character)
    }
}

extension EpisodeDetailViewModel {
    
    struct Action {
        let didTap: (RMCharacter) -> Void
    }
}
