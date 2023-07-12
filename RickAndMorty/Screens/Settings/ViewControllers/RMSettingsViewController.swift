//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit
import SwiftUI

/// Controller to show various app options and settings.
class RMSettingsViewController: UIViewController {

    private let setttingViewController = UIHostingController(
        rootView: RMSettingView(
            viewModel: RMSettingViewViewModel(
                cellViewModels: RMSettingOption.allCases.compactMap({
                    RMSettingCellViewViewModel(type: $0)
                })
            )
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        addChildViewController()
    }
    
    private func addChildViewController() {
        addChild(setttingViewController)
        setttingViewController.didMove(toParent: self)
        view.addSubview(setttingViewController.view)
        
        guard let settingView = setttingViewController.view else { return }
        settingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            settingView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            settingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
