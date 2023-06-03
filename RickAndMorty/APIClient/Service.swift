//
//  Service.swift
//  RickAndMorty
//
//  Created by Arun on 03/06/23.
//

import Foundation


/// Primary API service object to get Rick and Morty data
final class Service {
    
    /// Privatized constructor
    private init() {}
    
    /// Shared singleton instance
    static let shared = Service()
    
    
    /// Send Rick and Morty API call
    /// - Parameters:
    ///   - request: Request instace
    ///   - completion: Callback with data or error
    public func execute(_ request: Request, completion: @escaping () -> Void) {
        
    }
    
    
}
