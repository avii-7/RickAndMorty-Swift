//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 01/07/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    
    private var viewModel: RMEpisodeDetailViewViewModel
    
    init(viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
        // Not clear why we need to call this after property initialization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode Detail View Controller"
        view.backgroundColor = .systemBackground
        viewModel.fetchEpisodes()
    }
}
