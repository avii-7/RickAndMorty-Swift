//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit
import SwiftUI
import Networking

/// Controllers to house tabs and root tab controllers
final class RMTabBarViewController: UITabBarController {
    
    override func loadView() {
        super.loadView()
        
        setUpTabs()
    }
    
    private func setUpTabs() {
        let tabBarItemTitles = ["Characters", "Locations", "Episodes", "Settings"]
        let tabBarIcons = ["person", "globe", "tv", "gear"]
        
        let characterVC = UIHostingController(rootView: CharacterListNavigationView())
        let locationVC = RMLocationViewController()
        let episodesVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        var viewControllers: [UIViewController] = []
        
        for (index, vc) in [characterVC, locationVC, episodesVC, settingsVC].enumerated() {
            
            vc.navigationItem.largeTitleDisplayMode = .automatic
            
            let wrappedVC: UIViewController
            
            if index == 0 {
                vc.tabBarItem = UITabBarItem(
                    title: tabBarItemTitles[index],
                    image: UIImage(systemName: tabBarIcons[index]), tag: index)
                
                wrappedVC = vc
            }
            else {
                let navigationVC = UINavigationController(rootViewController: vc)
                navigationVC.navigationBar.prefersLargeTitles  = true
                
                navigationVC.tabBarItem = UITabBarItem(
                    title: tabBarItemTitles[index],
                    image: UIImage(systemName: tabBarIcons[index]), tag: index)
                
                wrappedVC = navigationVC
            }

            viewControllers.append(wrappedVC)
        }
        
        setViewControllers(viewControllers, animated: true)
    }
    
    private func getCharacterListViewController() -> UIViewController {
        let remoteSource = DefaultRemoteListSourceV2(httpClient: HTTPClient())
        let listSource = DefaultCharacterListSource(remoteListSource: remoteSource)
        let viewModel = CharacterListViewModel(listSource: listSource)
        let controller = UIHostingController(rootView: CharacterListView(viewModel: viewModel))
        return controller
    }
}
