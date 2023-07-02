//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by Arun on 02/07/23.
//

import Foundation

/// NSCache requires Data to be class type.
typealias ResponseCache = NSCache<NSString, NSData>

final class RMAPICacheManager {
    
    private var cacheResponse = ResponseCache()
    
    private var cacheDictionary = Dictionary<RMEndpoint, ResponseCache>()
    
    init() {
        setupCache()
    }
    
    // MARK: - Public function
    
    public func setCacheResponse(endPoint: RMEndpoint, url: URL?, data: Data) {
        guard let responseCache = cacheDictionary[endPoint] else { return }
        
        guard let url else { return }
        let key = NSString(string: url.absoluteString)
        let value = NSData(data: data)
        responseCache.setObject(value, forKey: key)
    }
    
    public func getCacheResponse(endPoint: RMEndpoint, for url: URL?) -> Data? {
        guard let responseCache = cacheDictionary[endPoint] else { return nil }
        
        guard let url else { return nil }
        let key = NSString(string: url.absoluteString)
        
        guard let response = responseCache.object(forKey: key) as? Data else { return nil }
        return response
    }
    
    
    // MARK: - Private function
    
    private func setupCache() {
        RMEndpoint.allCases.forEach { endPoint in
            cacheDictionary[endPoint] = ResponseCache()
        }
    }
}
