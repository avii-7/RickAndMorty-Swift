//
//  RMSettingOption.swift
//  RickAndMorty
//
//  Created by Arun on 10/07/23.
//

import UIKit

enum RMSettingOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact Us"
        case .terms:
            return "Terms of service"
        case .privacy:
            return "Privacy Policy"
        case .apiReference:
            return "API Reference"
        case .viewSeries:
            return "View Video Series"
        case .viewCode:
            return "View App Code"
        }
    }
    
    var displayImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane.fill")
        case .terms:
            return UIImage(systemName: "doc.fill")
        case .privacy:
            return UIImage(systemName: "lock.fill")
        case .apiReference:
            return UIImage(systemName: "list.clipboard.fill")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    var imageContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemPink
        case .contactUs:
            return .systemMint
        case .terms:
            return .systemGray
        case .privacy:
            return .systemBlue
        case .apiReference:
            return .systemRed
        case .viewSeries:
            return .systemCyan
        case .viewCode:
            return .systemTeal 
        }
    }
}

