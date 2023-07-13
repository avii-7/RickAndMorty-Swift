//
//  SettingsViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit
import SwiftUI
import StoreKit
import SafariServices

/// Controller to show various app options and settings.
class RMSettingsViewController: UIViewController {

    private var setttingViewController: UIHostingController<RMSettingView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Settings"
        addChildViewController()
    }
    
    private func addChildViewController() {
        setttingViewController = UIHostingController(
            rootView: RMSettingView(
                viewModel: RMSettingViewViewModel(
                    cellViewModels: RMSettingOption.allCases.compactMap({
                        RMSettingCellViewViewModel(type: $0) { [weak self] option in
                            self?.handleTap(for: option)
                        }
                    })
                )
            )
        )
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
    
    private func handleTap(for option: RMSettingOption) {
        if !Thread.current.isMainThread { return }
        
        if let url = option.targetUrl {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
        else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
