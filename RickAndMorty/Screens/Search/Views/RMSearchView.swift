//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

class RMSearchView: UIView {

    private let viewModel: RMSearchViewViewModel
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }

}
