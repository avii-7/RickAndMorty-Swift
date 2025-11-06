//
//  HTTPRequest+Extension.swift
//  RickAndMorty
//
//  Created by Avii 🔥  on 04/11/25.
//

import Networking
import Foundation

extension HTTPRequest {
    
    var baseURL: URL {
        URL(string: NetworkConstants.baseUrl)!
    }
}
