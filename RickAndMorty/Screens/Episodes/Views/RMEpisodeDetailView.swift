//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemRed
        addSubview(collectionView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    //MARK: - Public function
    
    public func configure(viewModel: RMEpisodeDetailViewViewModel) {
        
    }
    
    //MARK: - Private function
    
    private func addConstraints() {
        
    }
}
