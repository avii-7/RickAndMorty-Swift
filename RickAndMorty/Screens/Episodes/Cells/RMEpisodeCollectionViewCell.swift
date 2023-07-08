//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMEpisodeCollectionViewCell.self)
    
    private let verticalStackView: UIStackView = {
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        verticalStackView.spacing = 10
        verticalStackView.distribution = .equalSpacing
        verticalStackView.alignment = .fill
        return verticalStackView
    }()
    
    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        return nameLabel
    }()
    
    private let episodeLabel: UILabel = {
        let episodeLabel = UILabel()
        episodeLabel.lineBreakMode = .byTruncatingTail
        episodeLabel.font = .preferredFont(forTextStyle: .title2)
        return episodeLabel
    }()
    
    private let airDateLabel: UILabel = {
        let airDateLabel = UILabel()
        airDateLabel.lineBreakMode = .byTruncatingTail
        airDateLabel.font = .preferredFont(forTextStyle: .title3)
        return airDateLabel
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemGroupedBackground
        contentView.addSubview(verticalStackView)
        setupConstraints()
        setUpConentViewLayer()
        setUpVerticalStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    func setUpConentViewLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
    }
    
    func setUpVerticalStackView() {
        let leftView = UIView()
        verticalStackView.addArrangedSubview(leftView)
        
        for subView in [nameLabel, episodeLabel, airDateLabel] {
            verticalStackView.addArrangedSubview(subView)
        }
        
        let rightView = UIView()
        verticalStackView.addArrangedSubview(rightView)
    }
    
    private func registerForData() { }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            verticalStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 10),
            verticalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -10),
            verticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func configure(with viewModel: RMEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] result in
            guard let self else { return }
            self.nameLabel.text = result.name
            self.episodeLabel.text = result.episode
            self.airDateLabel.text = result.air_date
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        episodeLabel.text = nil
        airDateLabel.text = nil
        contentView.layer.borderColor = nil
    }
}
