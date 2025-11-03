//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 28/10/25.
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
    }
}

struct CharacterDetailView: View {
    
    @State var viewModel: CharacterDetailViewModel
    
    var body: some View {
        content
            .toolbarRole(.editor)
            .navigationTitle(viewModel.character.name)
    }
    
    private var content: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                if let imageUrl = URL(string: viewModel.character.image) {
                    CharacterDetailPhotoView(url: imageUrl)
                }
                
                Grid {
                    ForEach(Array(CharacterInfoType.allCases.chunked(into: 2).enumerated()), id: \.offset) { index, row in
                        GridRow(alignment: .top) {
                            ForEach(row) { info in
                                getRowContent(
                                    title: info.rawValue,
                                    value: info.getValue(using: viewModel.character),
                                    systemImageName: info.getSystemImageName(using: viewModel.character))
                            }
                        }
                        
                    }
                }
                
                if viewModel.character.episode.isEmpty == false {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 10) {
                            ForEach(viewModel.episodes) { episode in
                                getEpisodes(using: episode)
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
            .padding(.horizontal, 10)
            .padding(.bottom)
        }
    }
    
    private func getRowContent(title: String, value: String, systemImageName: String) -> some View {
        VStack(spacing: 10) {
            
            Label {
                Text(value)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
            icon: {
                Image(systemName: systemImageName)
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 35)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(BackgroundStyle().secondary)
            
            Text(title)
                .foregroundStyle(.primary)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
                .background(.black)
        }
        .frame(height: 150)
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
            
            Text(episode.episode)
                .font(.subheadline)
                .lineLimit(1)
            
            Text(episode.created)
                .font(.footnote)
                .foregroundStyle(Color(.secondaryLabel))
        }
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
            source: MockCharactersSource()
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
    
    init(character: RMCharacter, source: CharactersSource) {
        self.character = character
        self.source = source
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
}
