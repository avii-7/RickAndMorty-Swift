//
//  SearchResultsView.swift
//  RickAndMorty
//
//  Created by Arun on 28/07/23.
//

import UIKit

final class RMSearchResultsView: UIView {
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            processViewModel()
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RMLocationTableViewCell.self,
                           forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        tableView.isHidden = true
        tableView.alpha = 0
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemRed
        isHidden = true
        addSubviews(tableView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func processViewModel() {
        guard let viewModel else { return }
        
        switch viewModel {
        case .characters(let viewModels):
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView()
        case .episodes(let viewModels):
            setUpCollectionView()
        }
    }
    
    private func setUpTableView() {
        tableView.isHidden = false
    }
    
    private func setUpCollectionView() {
        
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}
