//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 18/07/23.
//

import UIKit

class RMLocationDetailViewController: UIViewController {
    
    private let detailView = RMLocationDetailView()
    
    private var viewModel: RMLocationDetailViewViewModel
    
    init(model: RMLocationDetailViewViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchResidents()
        //detailView.delegate = self
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func didTapShare() { }
}

extension RMLocationDetailViewController: RMNetworkDelegate {
    
    func didFetchData() {
        DispatchQueue.main.async{
            self.detailView.configure(model: self.viewModel)
        }
    }
}

extension RMLocationDetailViewController: RMSelectionDelegate {
    func didSelect<T>(with model: T) {
        guard let character = model as? RMCharacter else { return }
        
        let viewModel = RMCharacterDetailViewViewModel(with: character)
        let vc = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
