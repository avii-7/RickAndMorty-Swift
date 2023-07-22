//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import Foundation

final class RMSearchInputViewViewModel {
    
    enum RMDynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"
        
        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["female", "male", "genderless", "unknown"]
            case .locationType:
                return ["planet", "cluster", "microverse"]
            }
        }
    }
    
    private let moduleType: RMModuleType
    
    //MARK: - Init
    
    init(type: RMModuleType) {
        self.moduleType = type
    }
    
    public var hasDynamicOptions: Bool {
        switch moduleType {
        case .Character, .Location:
            return true
        case .Episode:
            return false
        }
    }
    
    public var options: [RMDynamicOption] {
        switch moduleType {
        case .Character:
            return [.status, .gender]
        case .Location:
            return [.locationType]
        case .Episode:
            return []
        }
    }
    
    public var searchPlaceholderText: String {
        switch moduleType {
        case .Character:
            return "Character Name"
        case .Location:
            return "Location Name"
        case .Episode:
            return "Episode Name"
        }
    }
}
