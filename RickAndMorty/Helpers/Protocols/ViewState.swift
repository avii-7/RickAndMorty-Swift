//
//  ViewState.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//

enum ViewState {
    case idle, loading, loaded, error
    
    
    var isLoading: Bool {
        self == .loading
    }
}
