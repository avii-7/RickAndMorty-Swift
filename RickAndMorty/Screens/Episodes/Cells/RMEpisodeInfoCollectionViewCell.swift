//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 09/07/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMEpisodeInfoCollectionViewCell.self)
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        return titleLabel
    }()
    
    let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.numberOfLines = 0
        valueLabel.font = .preferredFont(forTextStyle: .body)
        valueLabel.textAlignment = .center
        return valueLabel
    }()
    
    let leftOpaqueBox: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
    }()
    
    let rightOpaqueBox: UILayoutGuide = {
        let layoutGuide = UILayoutGuide()
        return layoutGuide
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        setUpLayer()
        contentView.addLayoutGuide(leftOpaqueBox)
        contentView.addLayoutGuide(rightOpaqueBox)
        contentView.addSubviews(titleLabel, valueLabel)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    // MARK: - Private function
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            leftOpaqueBox.topAnchor.constraint(equalTo: contentView.topAnchor),
            leftOpaqueBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            leftOpaqueBox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            leftOpaqueBox.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            rightOpaqueBox.topAnchor.constraint(equalTo: contentView.topAnchor),
            rightOpaqueBox.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            rightOpaqueBox.leadingAnchor.constraint(equalTo: leftOpaqueBox.trailingAnchor),
            rightOpaqueBox.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: leftOpaqueBox.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leftOpaqueBox.leadingAnchor, constant: 5),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: leftOpaqueBox.bottomAnchor, constant: -5),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: leftOpaqueBox.trailingAnchor, constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: leftOpaqueBox.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: leftOpaqueBox.centerXAnchor),
            
            valueLabel.topAnchor.constraint(greaterThanOrEqualTo: rightOpaqueBox.topAnchor, constant: 5),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo:  rightOpaqueBox.leadingAnchor, constant: 5),
            valueLabel.bottomAnchor.constraint(lessThanOrEqualTo: rightOpaqueBox.bottomAnchor, constant: -5),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightOpaqueBox.trailingAnchor, constant: -5),
            valueLabel.centerYAnchor.constraint(equalTo: rightOpaqueBox.centerYAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: rightOpaqueBox.centerXAnchor)
        ])
    }
    
    // MARK: - Public function
    
    func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.value
    }
}
