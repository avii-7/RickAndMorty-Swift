//
//  SearchView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 10/11/25.
//

import SwiftUI

struct SearchResult<InfoResults, V> where InfoResults: RMInfoResults, V: View {
    let mappedView: (InfoResults.T) -> V
}

extension SearchResult where InfoResults == RMAllCharacters {
    
    var mappedView: (RMCharacter) -> CharacterItemView {
        CharacterItemView.init
    }
}

extension SearchResult where InfoResults == RMAllLocations {
    
    var mappedView: (RMLocation) -> LocationItemView {
        LocationItemView.init
    }
}

struct SearchView<InfoResults, V>: View where InfoResults: RMInfoResults, V: View {
    
    @State private var characterName: String = .empty
    
    @State var viewModel: SearchViewModel<InfoResults>
    
    let searchResult: SearchResult<InfoResults, V>
    
    var body: some View {
        content
            .padding(.horizontal, ScreenEdgesHorizontalPadding)
            .toolbarRole(.editor)
            .navigationTitle(viewModel.selectedTab.searchTitle)
            .searchable(text: $characterName, placement: .navigationBarDrawer)
            .background(.black)
    }
    
    private var content: some View {
        VStack(spacing: SectionsVerticalPadding) {
            filterButtons
            searchResults
        }
    }
    
    private var filterButtons: some View {
        HStack {
            Group {
                
                Button {
                    
                } label: {
                    Text("Status")
                        .frame(maxWidth: .infinity)
                        .font(.body)
                        .padding(.vertical)
                        .background(BackgroundStyle().secondary)
                        .foregroundStyle(.white)
                }
                
                Button {
                    
                } label: {
                    Text("Gender")
                        .frame(maxWidth: .infinity)
                        .font(.body)
                        .padding(.vertical)
                        .background(BackgroundStyle().secondary)
                        .foregroundStyle(.white)
                }
            }
            .clipShape(.capsule)
        }
    }
    
    private var searchResults: some View {
        ScrollView {
            ForEach(viewModel.searchResults) { item in
                searchResult.mappedView(item)
            }
        }
    }
}

#Preview {
    NavigationStack {
//        SearchView(selectedTab: .characterNew)
//            .preferredColorScheme(.dark)
    }
}


@Observable @MainActor
final class SearchViewModel<InfoResults: RMInfoResults> {
    
    var searchResults: [InfoResults.T]  = []
    
    var viewState = ViewState.idle
    
    var paginationState: ViewState = .idle
    
    @ObservationIgnored
    var pageInfo: RMInfo? = nil
    
    @ObservationIgnored
    var hasMore: Bool { pageInfo?.next != nil }
    
    @ObservationIgnored
    var nextPage: Int = 1
    
    @ObservationIgnored
    private let listSource: SearchSource
    
    @ObservationIgnored
    private let action: Action
    
    let selectedTab: TabbarItem
    
    init(searchResults: [InfoResults.T], selectedTab: TabbarItem, listSource: SearchSource, action: Action) {
        self.searchResults = searchResults
        self.listSource = listSource
        self.action = action
        self.selectedTab = selectedTab
    }
    
    func fetchResults(query: String) {
        Task {
            do {
                let respone: InfoResults = try await listSource.search(query: query, for: selectedTab)
                self.searchResults = respone.results
                self.pageInfo = respone.info
            } catch {
                printError(error.localizedDescription)
            }
        }
    }
}

extension SearchViewModel {
    
    struct Action {
        let didTapCharacter: (RMCharacter) -> Void
        let didTapEpisode: (RMEpisode) -> Void
        let didTapLocation: (RMLocation) -> Void
    }
}
