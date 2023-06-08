//
//  CharacterViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show and seach by characters
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate {
    
    let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
    }
    
    private func setupView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: - RMCharacterListViewDelegate
    
    func rmCharacterListView(didSelectCharacter character: RMCharacter) {
        // open detail view controller for that character
        let viewModel = RMCharacterDetailViewModel(character)
        let vc = RMCharacterDetailViewController(viewModel: viewModel)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
