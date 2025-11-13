//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import SwiftUI

enum TabbarItem: Identifiable, CaseIterable {

    var id: Self { self }
    
    case characters
    case episodes
    case locations
    case settings
    case search
    
    
    var title: String {
        switch self {
        case .characters: "Characters"
        case .locations: "Locations"
        case .episodes: "Episodes"
        case .settings: "Settings"
        case .search: "Search"
        }
    }
    
    var searchTitle: String {
        switch self {
        case .characters: "Search Characters"
        case .episodes: "Search Episodes"
        case .locations: "Search Locations"
        default: .empty
        }
    }

    var systemIcons: String {
        switch self {
        case .characters: "person"
        case .locations: "globe"
        case .episodes: "tv"
        case .settings: "gear"
        case .search: "magnifyingglass"
        }
    }
    
    static var searchTabs: [TabbarItem] {
        [.characters, .locations, .episodes]
    }
}

struct RMTabView: View {

    @State private var selectedTab = TabbarItem.characters
    
    var body: some View {
        content
    }
    
    @ViewBuilder
    private var content: some View {
        if #available(iOS 18.0, *) {
            tabsForAbove17
        }
        else {
            tabsForBelow17
        }
    }
    
    @available(iOS 18.0, *)
    private var tabsForAbove17: some View {
        TabView(selection: $selectedTab) {
            ForEach(TabbarItem.allCases) { tab in
                Tab(tab.title, systemImage: tab.systemIcons, value: tab, role: tab == .search ? .search : nil) {
                    switch tab {
                    case .characters: CharacterCoordinatorView()
                    case .episodes: EpisodesCoordinatorView()
                    case .locations: LocationsCoordinatorView()
                    case .settings: SettingView()
                    case .search: Text("Search View")
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var tabsForBelow17: some View {
        TabView(selection: $selectedTab) {
            
            CharacterCoordinatorView()
                .id(TabbarItem.characters)
                .tabItem {
                    Label(TabbarItem.characters.title, systemImage: TabbarItem.characters.systemIcons)
                        
                }
            
            EpisodesCoordinatorView()
                .id(TabbarItem.episodes)
                .tabItem {
                    Label(TabbarItem.episodes.title, systemImage: TabbarItem.episodes.systemIcons)
                }
            
            LocationsCoordinatorView()
                .id(TabbarItem.locations)
                .tabItem {
                    Label(TabbarItem.locations.title, systemImage: TabbarItem.locations.systemIcons)
                }
        }
    }
}
