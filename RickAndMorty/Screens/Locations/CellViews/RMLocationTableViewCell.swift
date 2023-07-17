//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    
    static let cellIdentifier = String(describing: RMLocationTableViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(titleLabel)
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func addConstraint() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 105),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
    
    func config(with viewModel: RMLocationCellViewViewModel) {
        titleLabel.text = viewModel.name
    }
}
