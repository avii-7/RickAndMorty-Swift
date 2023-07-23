//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 01/07/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    
    private var viewModel: RMEpisodeDetailViewViewModel
    
    private let detailView = RMEpisodeDetailView()
    
    init(viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
        // Not clear why we need to call this after property initialization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        view.addSubview(detailView)
        addConstraints()
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchEpisodes()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapShare() {
        
    }
}

extension RMEpisodeDetailViewController: RMNetworkDelegate, RMSelectionDelegate {
    
    func didFetchData() {
        detailView.configure(viewModel: viewModel)
    }
    
    func didSelect<T>(with model: T) {
        guard let characterModel = model as? RMCharacter else { return }
        let viewModel = RMCharacterDetailViewViewModel(with: characterModel)
        let vc = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
