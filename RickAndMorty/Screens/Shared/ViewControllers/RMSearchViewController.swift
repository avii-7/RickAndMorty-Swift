//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Arun on 08/07/23.
//

import UIKit

enum SearchType {
    case Character, Location, Episode
}

final class RMSearchViewController: UIViewController {
    
    private let searchType: SearchType
    
    init(serachType : SearchType) {
        self.searchType = serachType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
}
