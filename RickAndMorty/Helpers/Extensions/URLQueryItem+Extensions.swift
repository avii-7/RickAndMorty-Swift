//
//  URLQueryItem+Extensions.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 31/10/25.
//

import Foundation

extension URLQueryItem {
    
    static func create(key: String, value: String?) -> Self? {
        
        if let value, value.isEmpty == false {
            return Self(name: key, value: value)
        }
        
        return nil
    }
    
    static func create(key: String, value: Int?) -> Self? {
        
        if let value {
            return Self(name: key, value: String(value))
        }
        
        return nil
    }
}
