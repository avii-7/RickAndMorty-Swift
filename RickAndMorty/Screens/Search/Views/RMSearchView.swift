//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

class RMSearchView: UIView {

    private let viewModel: RMSearchViewViewModel
    
    private let noSearchResultView = RMNoSearchResultView()
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(noSearchResultView)
        addconstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func addconstraints() {
        NSLayoutConstraint.activate([
            noSearchResultView.leadingAnchor.constraint(equalTo: leadingAnchor),
            noSearchResultView.trailingAnchor.constraint(equalTo: trailingAnchor),
            noSearchResultView.topAnchor.constraint(equalTo: topAnchor),
            noSearchResultView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
