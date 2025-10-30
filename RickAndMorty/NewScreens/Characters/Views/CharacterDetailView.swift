//
//  CharacterDetailView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 28/10/25.
//

import SwiftUI

struct CharacterDetailView: View {
    
    let character: RMCharacter
    
    var body: some View {
        content
    }
    
    private var content: some View {
        ScrollView {
            
        }
    }
}

#Preview {
    CharacterDetailView(character: .getDefault(index: 0))
}
