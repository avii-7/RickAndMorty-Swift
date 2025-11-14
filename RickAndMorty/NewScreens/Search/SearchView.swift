//
//  SearchView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 10/11/25.
//

import SwiftUI

enum SearchFilter: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case character, location, episode
    
    var title: String {
        self.rawValue.capitalized
    }
    
    var placeholder: String {
        switch self {
        case .character: "Search character..."
        case .location: "Search location..."
        case .episode: "Search episode..."
        }
    }
}

struct SearchView: View {
    
    private let columns = Array(repeating: GridItem(.flexible(), alignment: .top), count: 2)
    
    @State private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .padding(.horizontal, ScreenEdgesHorizontalPadding)
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer)
            .background(.black)
            .toolbar {
                if viewModel.selectedFilter == .character {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Character Filter", selection: $viewModel.selectedCharacterFilter) {
                                ForEach(CharacterFilter.allCases, id: \.self) { filter in
                                    Text(filter.rawValue)
                                }
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal.decrease")
                        }
                    }
                }
            }
            .task(id: viewModel.searchQuery) {
                await viewModel.fetchResults()
            }
            .onChange(of: viewModel.selectedFilter) { _, newValue in
                viewModel.reset()
            }
            .task(id: viewModel.selectedFilter) {
                await viewModel.fetchResults()
            }
    }
    
    private var content: some View {
        VStack(spacing: SectionsVerticalPadding) {
            filterButtons
            searchResults
        }
    }
    
    private var filterButtons: some View {
        Picker("Filters", selection: $viewModel.selectedFilter) {
            ForEach(SearchFilter.allCases) { filter in
                Text(filter.title)
            }
        }
        .pickerStyle(.segmented)
    }
    
    @ViewBuilder
    private var searchResults: some View {
        Group {
            switch viewModel.selectedFilter {
            case .character:
                CharacterListScrollView(
                    characters: viewModel.characters,
                    didTapCharacter: viewModel.action.didTapCharacter,
                    hasMore: viewModel.hasMore) {
                        viewModel.fetchNextPage()
                    }
            case .episode:
                EmptyView()
            case .location:
                EmptyView()
            }
        }
        .overlay {
            if viewModel.viewState == .idle || viewModel.viewState == .loaded {
                
                if (viewModel.selectedFilter == .character && viewModel.characters.isEmpty) {
                    ContentUnavailableView(
                        viewModel.viewState == .idle ? "Start searching!" : "No results found." ,
                        systemImage: "magnifyingglass"
                    )
                }
                else if viewModel.selectedFilter == .episode && viewModel.episodes.isEmpty {
                    ContentUnavailableView(
                        viewModel.viewState == .idle ? "Start searching!" : "No results found." ,
                        systemImage: "magnifyingglass"
                    )
                }
                else if viewModel.selectedFilter == .location && viewModel.locations.isEmpty {
                    ContentUnavailableView(
                        viewModel.viewState == .idle ? "Start searching!" : "No results found." ,
                        systemImage: "magnifyingglass"
                    )
                }
            }
            else {
                ContentUnavailableView.search
            }
        }
    }
    
    private var characters: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(Array(viewModel.characters.enumerated()), id: \.element.id) { index, character in
                Group {
                    if index == viewModel.characters.endIndex - 1 {
                        CharacterItemView(character: character)
                            .onAppear {
                                //                                viewModel.fetchNextPageCharacters()
                            }
                    }
                    else {
                        CharacterItemView(character: character)
                    }
                }
                .onTapGesture {
                    //                    viewModel.didTap(character)
                }
            }
        }
    }
}

//#Preview {
////    NavigationStack {
////        SearchView()
////            .preferredColorScheme(.dark)
////    }
//}

enum CharacterFilter: String, Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case all = "All"
    case status = "Status"
    case gender = "Gender"
}

@Observable @MainActor
final class SearchViewModel {
    
    private(set) var characters: [RMCharacter] = []
    
    private(set) var locations: [RMLocation] = []
    
    private(set) var episodes: [RMEpisode] = []
    
    private(set) var viewState = ViewState.idle
    
    private(set) var paginationState: ViewState = .idle
    
    private(set) var pageInfo: RMInfo? = nil
    
    var hasMore: Bool { pageInfo?.next != nil }
    
    var selectedFilter = SearchFilter.character
    
    var searchQuery: String = .empty
    
    var selectedCharacterFilter: CharacterFilter = .all
    
    @ObservationIgnored
    private(set) var nextPage: Int = 1
    
    @ObservationIgnored
    private let listSource: SearchSource
    
    @ObservationIgnored
    let action: Action
    
    init(listSource: SearchSource, action: Action) {
        self.listSource = listSource
        self.action = action
    }
    
    func fetchResults() async {
        do {
            
            try await Task.sleep(for: .seconds(0.5))
            
            if self.searchQuery.isEmpty {
                return
            }
            
            if viewState.isLoading {
                return
            }
            
            viewState = .loading
            
            switch selectedFilter {
            case .character:
                try await searchCharacter()
            case .location:
                try await searchLocation()
            case .episode:
                try await searchEpisode()
            }
            
            viewState = .loaded
        }
        catch is CancellationError {
            // Task cancelled.
            viewState = .idle
        }
        catch {
            printError(error)
            viewState = .error
        }
    }
    
    func fetchNextPage() {
        
        if self.paginationState.isLoading {
            return
        }
        
        paginationState = .loading
        
        Task {
            
            do {
                switch selectedFilter {
                case .character:
                    try await fetchCharactersNextPage()
                case .location:
                    try await fetchLocationsNextPage()
                case .episode:
                    try await fetchEpisodesNextPage()
                }
                
                paginationState = .loaded
            }
            catch {
                printError(error)
                paginationState = .error
            }
        }
    }
    
    func reset() {
        nextPage = 1
        pageInfo = nil
        viewState = .idle
        viewState = .idle
    }
}

// MARK: - Search Query
extension SearchViewModel {
    
    private func searchCharacter() async throws {
        let respone: RMAllCharacters = try await self.search()
        self.characters = respone.results
        self.pageInfo = respone.info
        self.nextPage += 1
    }
    
    private func searchEpisode() async throws {
        let respone: RMAllEpisodes = try await self.search()
        self.episodes = respone.results
        self.pageInfo = respone.info
        self.nextPage += 1
    }
    
    private func searchLocation() async throws {
        let respone: RMAllLocations = try await self.search()
        self.locations = respone.results
        self.pageInfo = respone.info
        self.nextPage += 1
    }
}

// MARK: - Pagination
extension SearchViewModel {
    
    private func fetchCharactersNextPage() async throws {
        let respone: RMAllCharacters = try await self.search()
        self.characters.append(contentsOf: respone.results)
        self.pageInfo = respone.info
        self.nextPage += 1
    }
    
    private func fetchEpisodesNextPage() async throws {
        let respone: RMAllEpisodes = try await self.search()
        self.episodes.append(contentsOf: respone.results)
        self.pageInfo = respone.info
        self.nextPage += 1
    }
    
    private func fetchLocationsNextPage() async throws {
        let respone: RMAllLocations = try await self.search()
        self.locations.append(contentsOf: respone.results)
        self.pageInfo = respone.info
        self.nextPage += 1
    }
}

// MARK: - Common Methods
extension SearchViewModel {
    
    private func search() async throws -> RMAllCharacters {
        let respone: RMAllCharacters = try await listSource.searchCharacter(query: self.searchQuery, page: nextPage)
        return respone
    }
    
    private func search() async throws -> RMAllEpisodes {
        let respone = try await listSource.searchEpisode(query: self.searchQuery, page: nextPage)
        return respone
    }
    
    private func search() async throws -> RMAllLocations {
        let respone = try await listSource.searchLocation(query: self.searchQuery, page: nextPage)
        return respone
    }
}

extension SearchViewModel {
    
    struct Action {
        let didTapCharacter: (RMCharacter) -> Void
        let didTapEpisode: (RMEpisode) -> Void
        let didTapLocation: (RMLocation) -> Void
    }
}
