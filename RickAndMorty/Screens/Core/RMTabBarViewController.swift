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
    
    enum TabbarItem: CaseIterable {
        case characterNew
        case character
        case locationNew
        case location
        case episode
        case settings
        
        var title: String {
            switch self {
            case .character, .characterNew: "Characters"
            case .location, .locationNew: "Locations"
            case .episode: "Episodes"
            case .settings: "Settings"
            }
        }
        
        var systemIcons: String {
            switch self {
            case .character, .characterNew: "person"
            case .location, .locationNew: "globe"
            case .episode: "tv"
            case .settings: "gear"
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        setUpTabs()
    }
    
    private func setUpTabs() {
        
        let characterVCNew = UIHostingController(rootView: CharacterCoordinatorView())
        let locationVCNew = UIHostingController(rootView: LocationsCoordinatorView())
        
        let characterVC = wrappedIntoNavigationVC(RMCharacterViewController())
        let locationVC = wrappedIntoNavigationVC(RMLocationViewController())
        let episodesVC = wrappedIntoNavigationVC(RMEpisodeViewController())
        let settingsVC = wrappedIntoNavigationVC(RMSettingsViewController())
        
        for (index, tabItem) in TabbarItem.allCases.enumerated() {
            
            let tabBarItem = UITabBarItem(
                title: tabItem.title,
                image: UIImage(systemName: tabItem.systemIcons),
                tag: index
            )
            
            switch tabItem {
            case .characterNew:
                characterVCNew.tabBarItem = tabBarItem
            case .character:
                characterVC.tabBarItem = tabBarItem
            case .locationNew:
                locationVCNew.tabBarItem = tabBarItem
            case .location:
                locationVC.tabBarItem = tabBarItem
            case .episode:
                episodesVC.tabBarItem = tabBarItem
            case .settings:
                settingsVC.tabBarItem = tabBarItem
            }
        }
        
        setViewControllers([locationVCNew, characterVCNew, characterVC, locationVC, episodesVC, settingsVC], animated: true)
    }
    
    private func wrappedIntoNavigationVC(_ vc: UIViewController) -> UINavigationController {
        vc.navigationItem.largeTitleDisplayMode = .automatic
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.prefersLargeTitles = true
        return navVC
    }
}
