//
//  EpisodesDIContainer.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 06/11/25.
//

import FactoryKit

final class EpisodesDIContainer: SharedContainer {
    
    static let shared = EpisodesDIContainer()
    
    let manager = ContainerManager()
}
