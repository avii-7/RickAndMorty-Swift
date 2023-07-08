//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = String(describing: RMEpisodeCollectionViewCell.self)

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.font = .preferredFont(forTextStyle: .title1)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private let episodeLabel: UILabel = {
        let episodeLabel = UILabel()
        episodeLabel.lineBreakMode = .byTruncatingTail
        episodeLabel.font = .preferredFont(forTextStyle: .title2)
        episodeLabel.translatesAutoresizingMaskIntoConstraints = false
        return episodeLabel
    }()
    
    private let airDateLabel: UILabel = {
        let airDateLabel = UILabel()
        airDateLabel.lineBreakMode = .byTruncatingTail
        airDateLabel.font = .preferredFont(forTextStyle: .title3)
        airDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return airDateLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .tertiarySystemGroupedBackground
        contentView.layer.cornerRadius = 8
        contentView.addSubviews(nameLabel, episodeLabel, airDateLabel)
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        setupConstraints()
    }
    
    private func registerForData() {
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            episodeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            episodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            episodeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            airDateLabel.topAnchor.constraint(equalTo: episodeLabel.bottomAnchor, constant: 10),
            airDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            airDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            airDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMEpisodeCollectionViewCellViewModel) {
        print("Configured Function")
        viewModel.registerForData { [weak self] result in
            guard let self else { return }
            self.nameLabel.text = result.name
            self.episodeLabel.text = result.episode
            self.airDateLabel.text = result.air_date
            //print("Fetching complete \(result.episode)")
        }
        viewModel.fetchEpisode()
    }
}
