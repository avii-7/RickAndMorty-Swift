//
//  FullScreenLoader.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 14/11/25.
//

import SwiftUI

struct FullScreenLoader: View {
    
    var body: some View {
        ProgressView {
            Text("Your content is loading...")
                .controlSize(.extraLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

#Preview {
    FullScreenLoader()
}
