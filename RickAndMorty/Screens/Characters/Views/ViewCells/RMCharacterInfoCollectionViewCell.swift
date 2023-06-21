//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIndentifier = String(describing: RMCharacterInfoCollectionViewCell.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //translatesAutoresizingMaskIntoConstraints = false
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpConstraints() {
        
    }
    
    public func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        
    }
    
    override func prepareForReuse() {
        
    }
}
