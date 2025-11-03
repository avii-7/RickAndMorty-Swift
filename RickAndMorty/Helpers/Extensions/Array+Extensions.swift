//
//  Array+Extensions.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 31/10/25.
//

import Foundation

extension Array {
    
    func chunked(into size: Int) -> [[Element]] {
        
        guard size > 0 else { return [] }
        
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
    
    func elementAtOrNil(at index: Index) -> Element? {
        if self.isEmpty {
            return nil
        }
        
        if index > -1 && index < self.count {
            return self[index]
        }
        
        return nil
    }
}

extension Array<URLQueryItem> {
    
    static func create(args: (key: String, value: String?)...) -> Self {
        let queryItems: [Element] = args.compactMap(Element.create(key:value:))
        return queryItems
    }
    
    static func create(args: (key: String, value: Int?)...) -> Self {
        let queryItems: [Element] = args.compactMap(Element.create(key:value:))
        return queryItems
    }
}
