//
//  Container+Network.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 30/10/25.
//

import Networking
import FactoryKit

extension SharedContainer {
    
    var httpClient: Factory<HTTPClient> {
        self { HTTPClient() }
            .singleton
    }
    
    var locationsSource: Factory<LocationsSource> {
        self { DefaultLocationsSource(httpClient: self.httpClient()) }
    }
    
    var charactersSource: Factory<CharactersSource> {
        self { DefaultCharactersSource(httpClient: self.httpClient()) }
    }
    
    var episodesSource: Factory<EpisodesSource> {
        self { DefaultEpisodesSource(httpClient: self.httpClient()) }
    }
    
    var searchSource: Factory<SearchSource> {
        self { DefaultSearchSource(httpClient: self.httpClient()) }
    }
}
