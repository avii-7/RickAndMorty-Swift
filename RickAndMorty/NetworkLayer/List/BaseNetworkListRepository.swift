//
//  BaseNetworkList.swift
//  RickAndMorty
//
//  Created by Arun on 23/01/24.
//

import Foundation

class BaseNetworkListRepository: ListProtocol {
    
    var next: String?
    
    private let networkRequest = NetworkRequest()
    
    func fetchInitial<T>(endPoint: RMNetworkEndpoint) async throws -> Result<T, ListError> where T : Pagination, T : Decodable {
        
        guard let urlRequest = endPoint.urlRequest else {
            return .failure(.invalidURL)
        }
        
        let response: Result<T, NetworkError> = try await networkRequest.hit(using: urlRequest)
        
        let result: Result<T, ListError>
        
        switch response {
        case .success(let success):
            next = success.info.next
            result = .success(success)
        default:
            result = .failure(.failed)
        }
        return result
    }
    
    func fetchAdditional<T>() async throws -> Result<T, ListError> where T : Decodable, T: Pagination {
        
        guard let next else {
            return .failure(.noMoreData)
        }
        
        guard let url = URL(string: next) else {
            return .failure(.invalidURL)
        }
        
        let urlRequest = URLRequest(url: url)
        
        let response: Result<T, NetworkError> = try await networkRequest.hit(using: urlRequest)
        
        let result: Result<T, ListError>
        
        switch response {
        case .success(let success):
            self.next = success.info.next
            result = .success(success)
        case .failure:
            result = .failure(.failed)
        }
        
        return result
    }
}
