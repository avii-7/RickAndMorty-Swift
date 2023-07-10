//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controller to show various app options and settings.
class RMSettingsViewController: UIViewController {

    private let viewModel = RMSettingViewViewModel(
        cellViewModels: RMSettingOption.allCases.compactMap({
            RMSettingCellViewViewModel(type: $0)
        })
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
    }
}
