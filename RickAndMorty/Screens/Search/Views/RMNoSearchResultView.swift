//
//  RMNoSearchResultView.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import UIKit

final class RMNoSearchResultView: UIView {
    
    let viewModel = RMNoSearchResultViewViewModel()
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let opaqueBox: UILayoutGuide = {
        let opaqueBox = UILayoutGuide()
        return opaqueBox
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = false
        translatesAutoresizingMaskIntoConstraints = false
        addLayoutGuide(opaqueBox)
        addSubviews(iconView, label)
        configView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func configView() {
        iconView.image = viewModel.image
        label.text = viewModel.title
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            opaqueBox.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 10),
            opaqueBox.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            opaqueBox.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10),
            opaqueBox.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10),
            opaqueBox.centerXAnchor.constraint(equalTo: centerXAnchor),
            opaqueBox.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            iconView.widthAnchor.constraint(equalToConstant: 100),
            iconView.heightAnchor.constraint(equalToConstant: 100),
            iconView.centerXAnchor.constraint(equalTo: opaqueBox.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: opaqueBox.topAnchor),
            
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: opaqueBox.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: opaqueBox.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: opaqueBox.bottomAnchor)
        ])
    }
}
