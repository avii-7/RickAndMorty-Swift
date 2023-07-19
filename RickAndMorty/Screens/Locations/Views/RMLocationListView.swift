//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Arun on 14/07/23.
//

import UIKit

final class RMLocationListView: UIView {
    
    private var viewModel = RMLocationViewViewModel()
    
    weak var selectionDelegate: SelectionDelegate?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alpha = 1
        tableView.isHidden = true
        tableView.register(
            RMLocationTableViewCell.self,
            forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier
        )
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner, tableView)
        addConstraints()
        spinner.startAnimating()
        configTableView()
        viewModel.delegate = self
        viewModel.selectionDelegate = self
        viewModel.fetchInitialLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configTableView() {
        tableView.dataSource = viewModel
        tableView.delegate = viewModel
    }
}

extension RMLocationListView: RMLocationViewViewModelDelegate {
    
    func didLoadInitialLocations() {
        spinner.stopAnimating()
        tableView.reloadData()
        tableView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 1
        }
    }
}

extension RMLocationListView: SelectionDelegate {
    
    func didSelect<T>(with model: T) {
        selectionDelegate?.didSelect(with: model)
    }
}
