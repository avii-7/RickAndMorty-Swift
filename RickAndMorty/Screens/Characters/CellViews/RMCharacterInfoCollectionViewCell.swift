//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let Indentifier = String(describing: RMCharacterInfoCollectionViewCell.self)
    
    private let titleContainerView: UIView = {
        let titleContainerView = UIView()
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.backgroundColor = .secondarySystemBackground
        return titleContainerView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .title3)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    private let verticalOpaqueBox: UILayoutGuide = {
        let opaqueBoxView = UILayoutGuide()
        return opaqueBoxView
    }()
    
    private let horizontalOpaqueBox: UILayoutGuide = {
        let opaqueBoxView = UILayoutGuide()
        return opaqueBoxView
    }()
    
    private let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.numberOfLines = 0
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        return valueLabel
    }()
    
    private let iconLabel: UIImageView = {
        let iconLabel = UIImageView()
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.contentMode = .scaleAspectFit
        return iconLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemGroupedBackground
        layer.cornerRadius = 8
        titleContainerView.addSubview(titleLabel)
        addLayoutGuide(verticalOpaqueBox)
        addLayoutGuide(horizontalOpaqueBox)
        addSubviews(titleContainerView, valueLabel, iconLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.33),
            
            titleLabel.centerXAnchor.constraint(equalTo: titleContainerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor),
            
            verticalOpaqueBox.leadingAnchor.constraint(equalTo: leadingAnchor),
            verticalOpaqueBox.trailingAnchor.constraint(equalTo: trailingAnchor),
            verticalOpaqueBox.topAnchor.constraint(equalTo: topAnchor),
            verticalOpaqueBox.bottomAnchor.constraint(equalTo: titleContainerView.topAnchor),
            
            horizontalOpaqueBox.leadingAnchor.constraint(greaterThanOrEqualTo: verticalOpaqueBox.leadingAnchor, constant: 10),
            horizontalOpaqueBox.trailingAnchor.constraint(lessThanOrEqualTo: verticalOpaqueBox.trailingAnchor, constant: -10),
            horizontalOpaqueBox.topAnchor.constraint(greaterThanOrEqualTo: verticalOpaqueBox.topAnchor, constant: 10),
            horizontalOpaqueBox.bottomAnchor.constraint(lessThanOrEqualTo: verticalOpaqueBox.bottomAnchor, constant: -10),
            horizontalOpaqueBox.centerXAnchor.constraint(equalTo: verticalOpaqueBox.centerXAnchor),
            horizontalOpaqueBox.centerYAnchor.constraint(equalTo: verticalOpaqueBox.centerYAnchor),
            
            iconLabel.widthAnchor.constraint(equalToConstant: 30),
            iconLabel.heightAnchor.constraint(equalToConstant: 30),
            iconLabel.centerYAnchor.constraint(equalTo: valueLabel.centerYAnchor),
            iconLabel.leadingAnchor.constraint(equalTo: horizontalOpaqueBox.leadingAnchor, constant: 5),
            iconLabel.topAnchor.constraint(greaterThanOrEqualTo: horizontalOpaqueBox.topAnchor),
            iconLabel.bottomAnchor.constraint(lessThanOrEqualTo: horizontalOpaqueBox.bottomAnchor),
            
            valueLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(equalTo: horizontalOpaqueBox.trailingAnchor, constant: -5),
            valueLabel.topAnchor.constraint(equalTo: horizontalOpaqueBox.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: horizontalOpaqueBox.bottomAnchor)
        ])
    }
    
     func configure(with viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.displayTitle
        valueLabel.text = viewModel.displayValue
        iconLabel.image = viewModel.displayImage
        iconLabel.tintColor = viewModel.tintColor
        titleLabel.textColor = viewModel.tintColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        valueLabel.text = nil
        iconLabel.image = nil
        iconLabel.tintColor = .label
        titleLabel.tintColor = .label
    }
}
