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
    
    private var searchResultHandler: ((RMSearchResult) -> Void)?
    
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
    
    func registerSearchResultHandler(_ block: @escaping (RMSearchResult) -> Void) {
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
        
        searchResultModel = model
        
        var searchResultType: RMSearchResultType?
        var nextResultUrl: String?
        
        if let characterResults = model as? RMAllCharacters {
            searchResultType = .characters(characterResults.results.compactMap({
                .init(
                    id: $0.id,
                    name: $0.name,
                    status: $0.status,
                    imageUrlString: $0.image
                )
            }))
            nextResultUrl = characterResults.info.next
        }
        else if let episodeResults = model as? RMAllEpisodes {
            searchResultType = .episodes(episodeResults.results.compactMap({
                .init(episodeUrl: URL(string: $0.url))
            }))
            nextResultUrl = episodeResults.info.next
        }
        else if let locationResults = model as? RMAllLocations {
            searchResultType = .locations(locationResults.results.compactMap({
                .init(location: $0)
            }))
            nextResultUrl = locationResults.info.next
        }
        
        if let searchResultType {
            let searchResult = RMSearchResult(searchResultType: searchResultType, nextResultURL: nextResultUrl)
            searchResultHandler?(searchResult)
        }
        else {
            noResultsHandler?()
        }
    }
    
    func set(query text: String) {
        searchedText = text
    }
    
    func getlocation(at indexPath: IndexPath) -> RMLocation?  {
        guard let locations = searchResultModel as? RMAllLocations else { return nil }
        guard let location = locations.results.elementAtOrNil(at: indexPath.row) else { return nil }
        return location
    }
    
    func getCharacter(at indexPath: IndexPath) -> RMCharacter? {
        guard let characters = searchResultModel as? RMAllCharacters else { return nil }
        guard let character = characters.results.elementAtOrNil(at: indexPath.row) else { return nil }
        return character
    }
    
    func getEpisode(at indexPath: IndexPath) -> RMEpisode? {
        guard let episodes = searchResultModel as? RMAllEpisodes else { return nil }
        guard let episode = episodes.results.elementAtOrNil(at: indexPath.row) else { return nil }
        return episode
    }
}

