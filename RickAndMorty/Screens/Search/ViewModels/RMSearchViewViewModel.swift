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
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
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
    
    func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
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
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(with: model)
            case .failure(let error):
                self?.noResultsHandler?()
                print(String(describing: error))
            }
        }
    }
    
    private func processSearchResults(with model: Codable) {
        
        var searchResultsVM: RMSearchResultViewModel?
        
        if let characterResults = model as? RMAllCharacters {
            searchResultsVM = .characters(characterResults.results.compactMap({
                .init(
                    id: $0.id,
                    name: $0.name,
                    status: $0.status,
                    imageUrlString: $0.image
                )
            }))
        }
        else if let episodeResults = model as? RMAllEpisodes {
            searchResultsVM = .episodes(episodeResults.results.compactMap({
                .init(episodeUrl: URL(string: $0.url))
            }))
        }
        else if let locationResults = model as? RMAllLocations {
            searchResultsVM = .locations(locationResults.results.compactMap({
                .init(location: $0)
            }))
        }
        
        if let searchResultsVM {
            searchResultHandler?(searchResultsVM)
        }
        else {
            noResultsHandler?()
        }
    }
    
    func set(query text: String) {
        searchedText = text
    }
}

