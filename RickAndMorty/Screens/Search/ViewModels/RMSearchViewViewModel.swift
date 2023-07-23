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
    
    private var searchedText = String.empty
    
    private var optionChangeBlock: ((RMDynamicOption, String) -> Void)?
    
    private var optionMap: [RMDynamicOption: String] = [:]
    
    private var searchResultHandler: (() -> Void)?
    //MARK: - Init
    
    init(_ searchType: RMSearchType) {
        self.searchType = searchType
    }
    
    // MARK: - Internal
    
    func set(value: String, for option: RMDynamicOption) {
        optionMap[option] = value
        optionChangeBlock?(option, value)
    }
    
    func registerOptionChangeBlock(
        _ block: @escaping (RMDynamicOption, String) -> Void
    ) {
        optionChangeBlock = block
    }
    
    func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    func executeSearch() {
        var queryParameters = [URLQueryItem]()
        
        if !searchedText.isEmpty {
            queryParameters.append(.init(name: "name", value: searchedText))
        }
        
        queryParameters.append(contentsOf: optionMap.compactMap({
            URLQueryItem(name: $0.key.networkKey, value: $0.value)
        }))
        let request = RMRequest(endpoint: searchType.moduleType.endPoint, queryParameters: queryParameters)
        
        RMService.shared.execute(request, expecting: RMAllCharacters.self) { [weak self] result in
            switch result {
            case .success(let success):
                self?.searchResultHandler?()
            case .failure:
                break
            }
        }
    }
    
    func set(query text: String) {
        searchedText = text
    }
}

