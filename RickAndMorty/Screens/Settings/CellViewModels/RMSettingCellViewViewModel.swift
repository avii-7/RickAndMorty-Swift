//
//  RMSettingCellViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 10/07/23.
//

import UIKit

struct RMSettingCellViewViewModel: Identifiable, Hashable {
    
    var id = UUID()
    
    private let type: RMSettingOption

    // MARK: - Init
    
    init(type: RMSettingOption){
        self.type = type
    }
    
    // MARK: - Public properties
    
    public var iconContainerColor: UIColor {
        type.imageContainerColor
    }
    
    public var image: UIImage? {
        type.displayImage
    }
    
    public var title: String {
        type.displayTitle
    }
}
