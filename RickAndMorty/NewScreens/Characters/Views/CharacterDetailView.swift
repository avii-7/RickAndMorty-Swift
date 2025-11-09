//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 28/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterDetailPhotoView: View {
    
    let url: URL
    
    var body: some View {
        WebImage(url: url) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .aspectRatio(contentMode: .fill)
        .containerRelativeFrame(.horizontal) { length, axis in
            axis == .horizontal ? length : 0.4
        }
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct CharacterDetailView: View {
    
    @State var viewModel: CharacterDetailViewModel
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
            .navigationTitle(viewModel.character.name)
    }
    
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: SectionsVerticalPadding) {
                if let imageUrl = URL(string: viewModel.character.image) {
                    CharacterDetailPhotoView(url: imageUrl)
                }
                
                Grid {
                    ForEach(Array(CharacterInfoType.allCases.chunked(into: 2).enumerated()), id: \.offset) { index, row in
                        GridRow(alignment: .top) {
                            ForEach(row) { info in
                                getRowContent(
                                    type: info,
                                    model: viewModel.character
                                )
                            }
                        }
                    }
                }
                
                if viewModel.character.episode.isEmpty == false {
                    ScrollView(.horizontal) {
                        LazyHStack(alignment: .top, spacing: 10) {
                            ForEach(viewModel.episodes) { episode in
                                getEpisodes(using: episode)
                                    .onTapGesture {
                                        viewModel.didTapEpisode(episode)
                                    }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .task {
                        if viewModel.episodes.isEmpty {
                            await viewModel.fetchEpisdes()
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 10, for: .scrollContent)
    }
    
    private func getRowContent(type: CharacterInfoType, model: RMCharacter) -> some View {
        VStack(spacing: 10) {
            
            Label {
                
                Group {
                    if type == .created {
                        Text(type.getValue(using: model), format: .rmCustomDate)
                    }
                    else {
                        Text(type.getValue(using: model))
                    }
                }
                .foregroundStyle(.secondary)
                .font(.subheadline)
            }
            icon: {
                Image(systemName: type.getSystemImageName(using: model))
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 35)
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(BackgroundStyle().secondary)
            
            Text(type.rawValue)
                .foregroundStyle(.primary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.black)
        }
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.5), lineWidth: 0.5)
        }
    }
    
    private func getEpisodes(using episode: RMEpisode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name)
                .font(.title3)
                .lineLimit(2, reservesSpace: true)
                .multilineTextAlignment(.leading)
            
            Text(episode.episode)
                .font(.subheadline)
                .lineLimit(1)
            
            Text(episode.created, format: .rmCustomDate)
                .font(.footnote)
                .foregroundStyle(Color(.secondaryLabel))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .containerRelativeFrame(.horizontal) { length, _ in
            length * 0.7
        }
        .background(.black)
        .clipShape(.rect(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(.white.opacity(0.5), lineWidth: 0.5)
            
        }
    }
}

#Preview {
    CharacterDetailView(
        viewModel: CharacterDetailViewModel(
            character: .getDefault(index: 0),
            source: MockCharactersSource(), action: .init(didTapEpisode: { _ in })
        )
    )
    .preferredColorScheme(.dark)
}

@Observable @MainActor
final class CharacterDetailViewModel {
    
    @ObservationIgnored
    let character: RMCharacter
    
    @ObservationIgnored nonisolated
    private let source: CharactersSource
    
    var episodes: [RMEpisode] = []
    
    @ObservationIgnored
    private let action: Action
    
    init(character: RMCharacter, source: CharactersSource, action: Action) {
        self.character = character
        self.source = source
        self.action = action
    }
    
    func fetchEpisdes() async {
        do {
            try await withThrowingTaskGroup(of: RMEpisode.self) { group in
                
                for url in character.episode {
                    group.addTask {
                        try await self.source.fetchEpisode(using: url)
                    }
                }
                
                for try await episode in group {
                    self.episodes.append(episode)
                }
            }
        }
        catch {
            printError(error)
        }
    }
    
    func didTapEpisode(_ episode: RMEpisode) {
        action.didTapEpisode(episode)
    }
}

extension CharacterDetailViewModel {
    
    struct Action {
        let didTapEpisode: (RMEpisode) -> Void
    }
}
