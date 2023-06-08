//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 08/06/23.
//

import UIKit


/// Controller to show detail information about single character
final class RMCharacterDetailViewController: UIViewController {

    let viewModel: RMCharacterDetailViewModel
    
    init(viewModel: RMCharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.name
    }
}
