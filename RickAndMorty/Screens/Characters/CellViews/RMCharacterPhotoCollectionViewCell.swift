//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    
    static let Indentifier = String(describing: RMCharacterPhotoCollectionViewCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        
        Task { @MainActor [weak self] in
            do {
                let response = try await viewModel.fetchImage()
                
                switch response {
                case .success(let imageData):
                    self?.imageView.image = UIImage(data: imageData)
                case .failure(let failure):
                    throw failure
                }
            }
            catch {
                debugPrint("Error \(error)")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
