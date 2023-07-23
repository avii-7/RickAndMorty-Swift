//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import Foundation
import UIKit

final class RMSearchViewViewModel: NSObject {
    
    let searchType: RMSearchType
    
    var searchedText = String.empty
    
    private var optionChangeBlock: ((RMDynamicOption, String) -> Void)?
    
    //MARK: - Init
    
    init(_ searchType: RMSearchType) {
        self.searchType = searchType
    }
    
    // MARK: - Public
    
    func set(value: String, for option: RMDynamicOption) {
        optionChangeBlock?(option, value)
    }
    
    func registerOptionChangeBlock(
        _ block: @escaping (RMDynamicOption, String) -> Void
    ) {
        optionChangeBlock = block
    }
    
    func executeSearch() {
        
    }
    
    func set(query text: String) {
        searchedText = text
    }
}

