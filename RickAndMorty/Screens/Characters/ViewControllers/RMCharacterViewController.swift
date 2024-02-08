//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach by characters
final class RMCharacterViewController: UIViewController {
    
    let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
        view.backgroundColor = .systemBackground
        title = "Characters"
        
        characterListView.delegate = self
        setupView()
        
        let remoteListSource = RemoteDataSource()
        let viewModel = RMCharacterListViewViewModel(listSource: remoteListSource)
        characterListView.viewModel = viewModel
        
        characterListView.loadInitialCharacters()
    }
    
    private func setupView() {
        view.addSubview(characterListView)
        
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(for: .Character)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RMCharacterViewController: RMCharacterListViewDelegate {
    
    func rmCharacterListView(didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(with: character)
        let vc = RMCharacterDetailViewController(viewModel: viewModel)
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
