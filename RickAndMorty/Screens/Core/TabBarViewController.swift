//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTabs()
    }
    
    func setUpTabs() {
        let tabBarItemTitles = ["Characters", "Locations", "Episodes", "Settings"]
        let tabBarIcons = ["person", "globe", "tv", "gear"]
        
        let locationVC = LocationViewController()
        let characterVC = CharacterViewController()
        let episodesVC = EpisodeViewController()
        let settingsVC = SettingsViewController()
        
        var viewControllers: [UINavigationController] = []

        for (index, vc) in [locationVC, characterVC, episodesVC, settingsVC].enumerated() {
            vc.navigationItem.largeTitleDisplayMode = .automatic
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.navigationBar.prefersLargeTitles  = true
            navigationVC.tabBarItem = UITabBarItem(title: tabBarItemTitles[index], image: UIImage(systemName: tabBarIcons[index]), tag: index)
            viewControllers.append(navigationVC)
        }

        setViewControllers(viewControllers, animated: true)
    }
}

