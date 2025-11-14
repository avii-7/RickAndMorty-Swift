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
    
    var body: some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Characters")
            .task {
                if viewModel.characters.isEmpty {
                    await viewModel.fetchInitialCharacters()
                }
            }
    }
    
    @ViewBuilder
    var content: some View {
        if viewModel.characters.isEmpty {
            FullScreenLoader()
        }
        else {
            CharacterListScrollView(
                characters: viewModel.characters,
                didTapCharacter: viewModel.didTap(_:),
                hasMore: viewModel.hasMore) {
                    viewModel.fetchNextPageCharacters()
                }
        }
    }
}

#Preview {
    NavigationStack {
//        CharacterListView(
//            viewModel: CharacterListViewModel(
//                listSource: MockCharactersSource(),
//                action: .init(didTapCharacter: { _ in }))
//        )
//        .preferredColorScheme(.dark)
    }
}

struct CharacterItemView: View {
    
    let character: RMCharacter
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            WebImage(url: URL(string: character.image)) { image in
                image
                    .resizable()
            }
            placeholder: {
                ProgressView()
                    .controlSize(.large)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .containerRelativeFrame(.vertical, { length, _ in
                        length * 0.25
                    })
            }
            .aspectRatio(1, contentMode: .fill)
            .containerRelativeFrame(.vertical) { length, _ in
                length * 0.25
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(character.name)
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                Text("Status: \(character.status.rawValue)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            
            Spacer(minLength: .zero)
        }
        .frame(maxWidth: .infinity)
        .background(BackgroundStyle().secondary)
        .clipShape(.rect(cornerRadius: 8))
    }
}
