//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 01/07/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    
    private var viewModel: RMEpisodeDetailViewViewModel
    
    private let detailView: RMEpisodeDetailView
    
    init(viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = .init(viewModel: viewModel)
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
        detailView.delegate = self
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

extension RMEpisodeDetailViewController: RMEpisodeDetailViewDelegate{
    
    func rmEpisodeDetailView(didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(with: character)
        let vc = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
