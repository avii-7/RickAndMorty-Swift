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
        
        view.addSubview(episodeListView)
        setupView()

        episodeListView.delegate = self
        let listSource = RemoteDataSource()
        let viewModel = RMEpisodeListViewViewModel(listSource: listSource)
        episodeListView.viewModel = viewModel
        episodeListView.loadInitialEpisodes()
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(for: .Episode)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupView() {
        
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMEpisodeViewController: RMEpisodeListViewDelegate {
    
    func rmEpisodeListView(didSelectEpisode episode: RMEpisode) {
        let viewModel = RMEpisodeDetailViewViewModel(episode: episode)
        let vc = RMEpisodeDetailViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
