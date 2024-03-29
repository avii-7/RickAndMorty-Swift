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
    
    private var searchResultHandler: ((RMSearchResultType) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    private var searchResultModel: Codable?
    
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
    
    func registerSearchResultHandler(_ block: @escaping (RMSearchResultType) -> Void) {
        self.searchResultHandler = block
    }
    
    func registerNoResultsHandler(_ block: @escaping () -> Void) {
        noResultsHandler = block
    }
    
    func executeSearch() {
        var queryParameters = [URLQueryItem]()
        
        if !searchedText.isEmpty {
            queryParameters.append(.init(name: "name", value: searchedText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        
        queryParameters.append(contentsOf: optionMap.compactMap({
            URLQueryItem(name: $0.key.networkKey, value: $0.value)
        }))
        
        let request = RMRequest(endpoint: searchType.moduleType.endPoint, queryParameters: queryParameters)
        switch searchType.moduleType {
        case .Character:
            makeSearchAPICall(for: RMAllCharacters.self, with: request)
        case .Episode:
            makeSearchAPICall(for: RMAllEpisodes.self, with: request)
        case .Location:
            makeSearchAPICall(for: RMAllLocations.self, with: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(for type: T.Type, with request: RMRequest) {
        Task {
            let result = await RMService.shared.execute(request, expecting: type)
            switch result {
            case .success(let model):
                processSearchResults(with: model)
            case .failure(let error):
                noResultsHandler?()
                print(String(describing: error))
            }
        }
    }
    
    private func processSearchResults(with model: Codable) {
        
        var searchResultType: RMSearchResultType?
        
        searchResultModel = model
        
        if let characterResults = model as? RMAllCharacters {
            let nextPageURL = characterResults.info.next
            let allCharacters = characterResults.results
            searchResultType = .characters(allCharacters, nextPageURL)
        }
        else if let episodeResults = model as? RMAllEpisodes {
            let nextPageURL = episodeResults.info.next
            let allEpisodes = episodeResults.results
            searchResultType = .episodes(allEpisodes, nextPageURL)
        }
        else if let locationResults = model as? RMAllLocations {
            let nextPageURL = locationResults.info.next
            let allLocations = locationResults.results
            searchResultType = .locations(allLocations, nextPageURL)
        }
        
        if let searchResultType {
            searchResultHandler?(searchResultType)
        }
        else {
            noResultsHandler?()
        }
    }
    
    func set(query text: String) {
        searchedText = text
    }
}

