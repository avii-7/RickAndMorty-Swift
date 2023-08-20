//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import Foundation

typealias RMDynamicOption = RMSearchInputViewViewModel.RMDynamicOption

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
        
        var networkKey: String {
            switch self {
            case .gender:
                return "gender"
            case .status:
                return "status"
            case .locationType:
                return "type"
            }
        }
    }
    
    private let moduleType: RMModuleType
    
    //MARK: - Init
    
    init(type: RMModuleType) {
        self.moduleType = type
    }
    
     var options: [RMDynamicOption] {
        switch moduleType {
        case .Character:
            return [.status, .gender]
        case .Location:
            return [.locationType]
        case .Episode:
            return []
        }
    }
    
     var searchPlaceholderText: String {
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
