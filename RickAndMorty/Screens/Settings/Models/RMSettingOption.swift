//
//  RMSettingOption.swift
//  RickAndMorty
//
//  Created by Arun on 10/07/23.
//

import SwiftUI

enum RMSettingOption: Identifiable, CaseIterable {
    
    var id: Self { self }
    
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    var displayTitle: String {
        switch self {
        case .rateApp: "Rate App"
        case .contactUs: "Contact Us"
        case .terms: "Terms of service"
        case .privacy: "Privacy Policy"
        case .apiReference: "API Reference"
        case .viewSeries: "View Video Series"
        case .viewCode: "View App Code"
        }
    }
    
    var systemImageName: String {
        switch self {
        case .rateApp: "star.fill"
        case .contactUs: "paperplane.fill"
        case .terms: "doc.fill"
        case .privacy: "lock.fill"
        case .apiReference: "list.clipboard.fill"
        case .viewSeries: "tv.fill"
        case .viewCode: "hammer.fill"
        }
    }
    
    var imageContainerColor: Color {
        switch self {
        case .rateApp: .pink
        case .contactUs: .mint
        case .terms: .gray
        case .privacy: .blue
        case .apiReference: .red
        case .viewSeries: .cyan
        case .viewCode: .teal
        }
    }
    
    var targetUrl: URL? {
        
        let urlString: String?
        
        switch self {
        case .contactUs:
            urlString = "https://iosacademy.io"
        case .terms:
            urlString = "https://iosacademy.io/terms"
        case .privacy:
            urlString = "https://iosacademy.io/privacy"
        case .apiReference:
            urlString = "https://rickandmortyapi.com/documentation/#introduction"
        case .viewSeries:
            urlString = "https://youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y"
        case .viewCode:
            urlString = "https://github.com/avii-7/RickAndMorty-Swift"
        default:
            urlString = nil
        }
        
        if let urlString, urlString.isEmpty == false {
            return URL(string: urlString)
        }
        else {
            return nil
        }
    }
}
