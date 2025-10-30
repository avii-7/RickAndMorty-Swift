//
//  CharacterDIContainer.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 30/10/25.
//

import FactoryKit

final class CharacterDIContainer: SharedContainer {
    
    static let shared = CharacterDIContainer()
    
    let manager = ContainerManager()
    
    var characterListSource: Factory<CharacterListSource> {
        self { DefaultCharacterListSource(httpClient: self.httpClient()) }
    }
}
