//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Arun on 22/07/23.
//

import Foundation
import UIKit

final class RMSearchViewViewModel: NSObject, @unchecked Sendable {
    
    let searchType: RMSearchType
    
    private let optionMap: TypeSafeDictionary<RMDynamicOption, String> = .init()
    
    private var searchResultHandler: (@MainActor (RMSearchResultType) -> Void)?
    
    private var noResultsHandler: (@MainActor () -> Void)?
    
    private var optionChangeBlock: (@MainActor (RMDynamicOption, String) -> Void)?
    
    //MARK: - Init
    init(_ searchType: RMSearchType) {
        self.searchType = searchType
    }
    
    @MainActor
    func set(value: String, for option: RMDynamicOption) {
        optionMap.set(value, forKey: option)
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
    
    func executeSearch(with text: String) async {
        
        var queryParameters = [URLQueryItem]()
        
        if !text.isEmpty {
            queryParameters.append(.init(name: "name", value: text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))
        }
        
        queryParameters.append(
            contentsOf: optionMap.getAll().compactMap { URLQueryItem(name: $0.key.networkKey, value: $0.value)
        })
        
        let request = RMRequest(endpoint: searchType.moduleType.endPoint, queryParameters: queryParameters)
        
        switch searchType.moduleType {
        case .Character:
            await makeSearchAPICall(for: RMAllCharacters.self, with: request)
        case .Episode:
            await makeSearchAPICall(for: RMAllEpisodes.self, with: request)
        case .Location:
            await makeSearchAPICall(for: RMAllLocations.self, with: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable & Sendable>(for type: T.Type, with request: RMRequest) async {
        let result = await RMService.shared.execute(request, expecting: type)
        switch result {
        case .success(let model):
            await self.processSearchResults(with: model)
        case .failure(let error):
            await noResultsHandler?()
            print(String(describing: error))
        }
    }
    
    private func processSearchResults(with model: Codable) async {
        
        var searchResultType: RMSearchResultType?
        
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
            await searchResultHandler?(searchResultType)
        }
        else {
            await noResultsHandler?()
        }
    }
}


final class TypeSafeDictionary<P: Hashable & Sendable, Q: Sendable>: @unchecked Sendable {
    
    private let dispatchQueue = DispatchQueue(label: "com.avii.typeSafeDictionary")
    
    private var dictionary: [P: Q] = [:]
    
    public init() { }
    
    func set(_ value: Q, forKey key: P) {
        dispatchQueue.async(flags: .barrier) { [weak self] in
            self?.dictionary[key] = value
        }
    }
    
    func get(for key: P) -> Q? {
        dispatchQueue.sync {
            self.dictionary[key]
        }
     }
    
    func getAll() -> [P: Q] {
        dispatchQueue.sync {
            self.dictionary
        }
    }
}
