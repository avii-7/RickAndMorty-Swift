//
//  UICollectionViewWrapper.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 28/10/25.
//

import Foundation
import SwiftUI

// gist: https://gist.github.com/wtsnz/73f7c6840d2711e1c5e4b0564882e61c

struct UICollectionViewWrapper: UIViewRepresentable {
    
    private let layout: UICollectionViewLayout
    
    func makeUIView(context: Self.Context) -> UICollectionView {
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        
    }
}
