//
//  NetworkUtils.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 31/10/25.
//

enum NetworkUtils {
    
    static func removeBaseUrl(from urlString: String) -> String {
        let baseUrl = NetworkConstants.baseUrl
        
        var mutlableString = urlString
        
        if urlString.hasPrefix(baseUrl) {
            mutlableString.removeFirst(baseUrl.count)
        }
        
        return mutlableString
    }
}
