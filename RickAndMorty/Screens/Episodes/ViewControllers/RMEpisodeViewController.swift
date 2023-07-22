//
//  EpisodeViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach by episodes
final class RMEpisodeViewController: UIViewController {
    
    let episodeListView = RMEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Episodes"
        episodeListView.delegate = self
        setupView()
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(for: .Episode)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView() {
        
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMEpisodeViewController: RMSelectionDelegate {
    func didSelect<T>(with model: T) {
        guard let episodeModel = model as? RMEpisode else { return }
        let viewModel = RMEpisodeDetailViewViewModel(url: URL(string: episodeModel.url))
        let vc = RMEpisodeDetailViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
