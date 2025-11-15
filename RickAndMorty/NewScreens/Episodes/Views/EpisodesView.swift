//
//  EpisodesView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 04/11/25.
//

import SwiftUI

struct EpisodesView: View {
    
    @State var viewModel: EpisodeListViewModel
    
    var body: some View {
        content
            .navigationTitle("Episodes")
            .task {
                if viewModel.episodes.isEmpty {
                    await viewModel.fetchInitialEpisodes()
                }
            }
    }
    
    private var content: some View {
        EpisodeListView(
            episodes: viewModel.episodes,
            didTap: viewModel.didTapEpisode(_:),
            hasMore: viewModel.hasMore) {
                viewModel.fetchNextPage()
            }
    }
    
    private func getEpisodeRow(_ episode: RMEpisode) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name)
                .foregroundStyle(.white)
                .font(.title3)
            
            Text(episode.episode)
                .foregroundStyle(.white.secondary)
                .font(.subheadline)
            
            Text(episode.airDate)
                .foregroundStyle(.white)
                .font(.body)
                .foregroundStyle(.white.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
    }
}

//#Preview {
//    EpisodeListView()
//}

@Observable
@MainActor
final class EpisodeListViewModel {
    
    var episodes: [RMEpisode] = []
    
    var viewState = ViewState.idle
    
    var paginationState: ViewState = .idle
    
    @ObservationIgnored
    var pageInfo: RMInfo? = nil
    
    @ObservationIgnored
    var hasMore: Bool { pageInfo?.next != nil }
    
    @ObservationIgnored
    var nextPage: Int = 1
    
    @ObservationIgnored
    private let listSource: EpisodesSource

    @ObservationIgnored
    private let action: Action
    
    init(listSource: EpisodesSource, action: Action) {
        self.listSource = listSource
        self.action = action
    }
    
    func fetchInitialEpisodes() async {
        
        if viewState.isLoading { return }
        
        viewState = .loading
        
        do {
            let response: RMAllEpisodes = try await listSource.fetchAllEpisodes(pageNo: nextPage)
            self.episodes = response.results
            self.pageInfo = response.info
            if pageInfo?.next != nil { nextPage += 1 }
            viewState = .loaded
        }
        catch {
            printError(error)
            viewState = .error
        }
    }
    
    func fetchNextPage() {
        
        if paginationState.isLoading { return }
        
        paginationState = .loading
        
        Task {
            do {
                let response: RMAllEpisodes = try await listSource.fetchAllEpisodes(pageNo: nextPage)
                self.episodes.append(contentsOf: response.results)
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
    
    func didTapEpisode(_ episode: RMEpisode) {
        action.didTapEpisode(episode)
    }
}

extension EpisodeListViewModel {
    
    struct Action {
        let didTapEpisode: (RMEpisode) -> Void
    }
}

struct EpisodeListView: View {
    
    let episodes: [RMEpisode]
    
    let didTap: (RMEpisode) -> Void
    
    let hasMore: Bool
    
    let onPaginationTrigger: () -> Void
    
    var body: some View {
        List {
            ForEach(Array(episodes.enumerated()), id: \.offset) { index, episode in
                Group {
                    if index == episodes.count - 1 {
                        EpisodeItemView(episode: episode)
                            .onAppear {
                                onPaginationTrigger()
                            }
                    }
                    else {
                        EpisodeItemView(episode: episode)
                    }
                }
                .onTapGesture {
                    didTap(episode)
                }
            }
            
            if hasMore {
                ProgressView()
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

struct EpisodeItemView: View {
    
    let episode: RMEpisode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(episode.name)
                .foregroundStyle(.white)
                .font(.title3)
            
            Text(episode.episode)
                .foregroundStyle(.white.secondary)
                .font(.subheadline)
            
            Text(episode.airDate)
                .foregroundStyle(.white)
                .font(.body)
                .foregroundStyle(.white.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(.rect)
    }
}
