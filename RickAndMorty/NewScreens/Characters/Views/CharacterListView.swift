//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 26/10/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharacterListView: View {
    
    @State var viewModel: CharacterListViewModel
    
    private let gridItems = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        content
            .navigationTitle("Characters")
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.fetchInitialCharacters()
                }
            }
    }
    
    private var content: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 10) {
                    ForEach(viewModel.characters) { character in
                        CharacterItemView(character: character, parentSize: geometry.size)
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}

#Preview {
    NavigationStack {
        CharacterListView(
            viewModel: CharacterListViewModel(listSource: MockCharacterListSource())
        )
        .preferredColorScheme(.dark)
    }
}

struct CharacterItemView: View {
    
    let character: RMCharacter
    
    let parentSize: CGSize
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: character.image))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: parentSize.width / 2, maxHeight: parentSize.width / 2)
            
            Group {
                Text(character.name)
                    .font(.title)
                    .foregroundStyle(.primary)
                
                Text("Status: \(character.status.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 10)
        }
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 8))
    }
}
