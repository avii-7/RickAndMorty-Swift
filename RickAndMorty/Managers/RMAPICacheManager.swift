//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

/// NSCache requires Data to be class type.
typealias ResponseCache = NSCache<NSString, NSData>

actor RMAPICacheManager: Sendable {
    
    private let cacheDictionary: Dictionary<RMEndpoint, ResponseCache> = {
        var dict = [RMEndpoint: ResponseCache]()
        RMEndpoint.allCases.forEach { endPoint in
            dict[endPoint] = ResponseCache()
        }
        return dict
    }()
    
    // MARK: -  function
     func setCacheResponse(endPoint: RMEndpoint, url: URL?, data: Data) {
        guard let responseCache = cacheDictionary[endPoint] else { return }
        
        guard let url else { return }
        let key = NSString(string: url.absoluteString)
        let value = NSData(data: data)
        responseCache.setObject(value, forKey: key)
    }
    
     func getCacheResponse(endPoint: RMEndpoint, for url: URL?) -> Data? {
        guard let responseCache = cacheDictionary[endPoint] else { return nil }
        
        guard let url else { return nil }
        let key = NSString(string: url.absoluteString)
        
        guard let response = responseCache.object(forKey: key) as? Data else { return nil }
        return response
    }
}
