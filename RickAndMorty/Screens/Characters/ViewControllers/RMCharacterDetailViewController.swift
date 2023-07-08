//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import UIKit

/// Controller to show detail information about single character
final class RMCharacterDetailViewController: UIViewController {

    let viewModel: RMCharacterDetailViewViewModel
    let detailView: RMCharacterDetailView
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        detailView = RMCharacterDetailView(frame: .zero, viewModel)
        super.init(nibName: nil, bundle: nil)
        // Why error ? when we used self before super.init call ?
        detailView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        view.addSubview(detailView)
        addConstraints()
    }
    
    @objc
    private func didTapShare() {
        
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.name
    }
}

extension RMCharacterDetailViewController: RMCharacterDetailViewDelegate {
    func didSelectItem(indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        
        switch sectionType {
        case .information, .photo:
            break
        case .episodes(let viewModel):
            guard let episodeUrl = viewModel[indexPath.row].episodeUrl
            else { return }
            
            let viewModel = RMEpisodeDetailViewViewModel(url: episodeUrl)
            let vc = RMEpisodeDetailViewController(viewModel: viewModel)
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
