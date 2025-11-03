//
//  LocationsDIContainer.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//

import FactoryKit

final class LocationsDIContainer: SharedContainer {
    
    static let shared = LocationsDIContainer()
    
    let manager = ContainerManager()
}
