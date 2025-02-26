//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Arun on 18/06/23.
//

import Foundation

final class RMImageManager: @unchecked Sendable {
    
    private init() {}
    
    static let shared = RMImageManager()
    
    private let dispatchQueue = DispatchQueue(label: "cache.queue", attributes: .concurrent)
    
    func getCache(for key: String) -> NSData? {
        dispatchQueue.sync {
            imageDataCache.object(forKey: key as NSString)
        }
    }
    
    func setCache(_ data: Data, for key: String) {
        dispatchQueue.async(flags: .barrier) {
            self.imageDataCache.setObject(data as NSData, forKey: key as NSString)
        }
    }
    
    private let imageDataCache = NSCache<NSString, NSData>()
    
    /// Get image from URL
    /// - Parameters:
    ///   - url: Image URL object
    func downloadImage(from url: URL) async throws -> Result<Data, NetworkError> {
        let key = url.absoluteString
        
        if let data = getCache(for: key) {
            return .success(data as Data)
        }
        
        let request = URLRequest(url: url)
        
        let response: (Data, URLResponse) = try await NetworkRequest.shared.hit(using: request)
        
        guard let httpResponse = (response.1 as? HTTPURLResponse),
              200...299 ~= httpResponse.statusCode else {
            return .failure(NetworkError.statusCodeError)
        }
        
        setCache(response.0, for: key)
        return .success(response.0)
    }
}
