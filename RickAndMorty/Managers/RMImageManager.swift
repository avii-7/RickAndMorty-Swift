//
//  RMImageManager.swift
//  RickAndMorty
//
//  Created by Arun on 18/06/23.
//

import Foundation

final class RMImageManager {

    private init() {}
    
    public static let shared = RMImageManager()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    /// Get image image from URL
    /// - Parameters:
    ///   - url: Image URL object
    ///   - completion: callback
    public func downloadImage(from url: URL, completion: @escaping (Result<Data, Error>) -> Void ) {
        let key = url.absoluteString as NSString
        
        if let data = imageDataCache.object(forKey: key) {
            completion(.success((data as Data)))
            return
        }
            
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self]data, _, error in
            guard let data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            self?.imageDataCache.setObject(data as NSData, forKey: key)
            completion(.success(data))
        }
        
        task.resume()
    }
}
