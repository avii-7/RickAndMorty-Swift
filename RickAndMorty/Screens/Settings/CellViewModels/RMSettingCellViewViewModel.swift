//
//  RMSettingCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 10/07/23.
//

import UIKit

struct RMSettingCellViewViewModel: Identifiable {
    
    var id = UUID()
    
    public let type: RMSettingOption
    
    public let onTapHandler: (RMSettingOption) -> Void
    
    // MARK: - Init
    
    init(type: RMSettingOption, onTapHandler: @escaping (RMSettingOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
    // MARK: - Internal properties
    
    var iconContainerColor: UIColor {
        type.imageContainerColor
    }
    
    var image: UIImage? {
        type.displayImage
    }
    
    var title: String {
        type.displayTitle
    }
}
