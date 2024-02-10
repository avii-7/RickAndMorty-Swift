//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Arun on 18/06/23.
//

import Foundation

final class RMImageManager {
    
    private init() {}
    
    static let shared = RMImageManager()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    /// Get image from URL
    /// - Parameters:
    ///   - url: Image URL object
    func downloadImage(from url: URL) async throws -> Result<Data, NetworkError> {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            return .success(data as Data)
        }
        
        let request = URLRequest(url: url)
        
        let response: (Data, URLResponse) = try await NetworkRequest.shared.hit(using: request)
        
        guard let httpResponse = (response.1 as? HTTPURLResponse),
              200...299 ~= httpResponse.statusCode else {
            return .failure(NetworkError.statusCodeError)
        }
        
        imageDataCache.setObject(response.0 as NSData, forKey: key)
        return .success(response.0)
    }
}
