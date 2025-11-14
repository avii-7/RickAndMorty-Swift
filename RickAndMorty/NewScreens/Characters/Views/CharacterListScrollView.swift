//
//  CharacterListScrollView.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 14/11/25.
//

import SwiftUI

struct CharacterListScrollView: View {
    
    private let columns = Array(repeating: GridItem(.flexible(), alignment: .top), count: 2)
    
    let characters: [RMCharacter]
    
    let didTapCharacter: (RMCharacter) -> Void
    
    let hasMore: Bool
    
    let onPaginationTrigger: () -> Void
    
    var body: some View {
        content
    }
    
    private var content: some View {
        ScrollView {
            Section {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(Array(characters.enumerated()), id: \.element.id) { index, character in
                        Group {
                            if index == characters.endIndex - 1 {
                                CharacterItemView(character: character)
                                    .onAppear {
                                        onPaginationTrigger()
                                    }
                            }
                            else {
                                CharacterItemView(character: character)
                            }
                        }
                        .onTapGesture {
                            didTapCharacter(character)
                        }
                    }
                }
            }
            footer: {
                if hasMore {
                    ProgressView("Wait we are fetching new content...")
                        .controlSize(.regular)
                }
            }
        }
        .contentMargins(.horizontal, 10, for: .scrollContent)
        .defaultScrollAnchor(.top)
    }
}
