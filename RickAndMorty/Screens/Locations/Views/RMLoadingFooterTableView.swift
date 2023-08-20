//
//  RMLoadingFooterTableView.swift
//  RickAndMorty
//
//  Created by Arun on 19/08/23.
//

import UIKit

class RMLoadingFooterTableView: UITableViewHeaderFooterView {

    static let cellIdentifier = String(describing: RMLoadingFooterTableView.self)
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = UIView(frame: frame)
        backgroundView?.backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
     func startAnimating() {
        spinner.startAnimating()
    }
}
