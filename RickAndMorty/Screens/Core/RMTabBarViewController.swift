//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

/// Controllers to house tabs and root tab controllers
final class RMTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }
    
    func setUpTabs() {
        let tabBarItemTitles = ["Characters", "Locations", "Episodes", "Settings"]
        let tabBarIcons = ["person", "globe", "tv", "gear"]
        
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodesVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        var viewControllers: [UINavigationController] = []
        
        for (index, vc) in [characterVC, locationVC, episodesVC, settingsVC].enumerated() {
            vc.navigationItem.largeTitleDisplayMode = .automatic
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.navigationBar.prefersLargeTitles  = true
            navigationVC.tabBarItem = UITabBarItem(
                title: tabBarItemTitles[index],
                image: UIImage(systemName: tabBarIcons[index]), tag: index)
            viewControllers.append(navigationVC)
        }
        
        setViewControllers(viewControllers, animated: true)
    }
}

