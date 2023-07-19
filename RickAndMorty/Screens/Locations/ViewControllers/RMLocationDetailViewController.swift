//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Arun on 18/07/23.
//

import UIKit

class RMLocationDetailViewController: UIViewController {
    
    private var model: RMLocation
    
    init(model: RMLocation) {
        self.model = model
        super.init(nibName: nil, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported !")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
    }
}
