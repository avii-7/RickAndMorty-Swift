//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 20/06/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: `Type`
    
     var displayTitle: String {
        type.rawValue
    }
    
    private let value: String
    
     var displayValue: String {
        if value.isEmpty { return "None" }
        else if type == .created {
            let formattedDate = RMDateFormatter.getFormattedDate(for: value)
            return formattedDate
        }
        return value
    }
    
     var displayImage: UIImage? {
        return type.iconImage
    }
    
     var tintColor: UIColor {
        return type.tintColor
    }
    
    
    
    enum `Type`: String {
        case status = "STATUS"
        case gender = "GENDER"
        case type = "TYPE"
        case species = "SPECIES"
        case origin = "ORIGIN"
        case location = "LOCATION"
        case created = "CREATED"
        case episodeCount = "EPISODE COUNT"
        
//        var displayTitle: String {
//            switch self {
//            case .status:
//                return "Status"
//            case .gender:
//                return "Gender"
//            case .type:
//                return "Type"
//            case .species:
//                return "Species"
//            case .origin:
//                return "Origin"
//            case .location:
//                return "Location"
//            case .created:
//                return "Created"
//            case .episodeCount:
//                return "Episode Count"
//            }
//        }
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemRed
            case .gender:
                return .systemBlue
            case .type:
                return .systemYellow
            case .species:
                return .systemCyan
            case .origin:
                return .systemMint
            case .location:
                return .systemPink
            case .created:
                return .systemPurple
            case .episodeCount:
                return .systemTeal
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.type = type
        self.value = value
    }
}
