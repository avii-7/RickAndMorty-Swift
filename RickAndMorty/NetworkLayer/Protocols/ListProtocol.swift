//
//  ListProtocol.swift
//  RickAndMorty
//
//  Created by Arun on 22/01/24.
//

import Foundation

protocol ListProtocol {
    
    var next: String? { get set }
    
    func fetchInitial<T: Decodable & Pagination>(endPoint: RMNetworkEndpoint) async throws -> Result<T, ListError>
    
    func fetchAdditional<T: Decodable & Pagination>() async throws -> Result<T, ListError>
}

protocol Pagination {
    associatedtype Info: Next
    var info: Info { get }
}

protocol Next {
    var next: String? { get }
}

enum ListError: Error {
    case noMoreData
    case invalidURL
    case failed
}
