//
//  SelectionProtocol.swift
//  RickAndMorty
//
//  Created by Arun on 18/07/23.
//

import Foundation

@MainActor
protocol RMSelectionDelegate: AnyObject {
    func didSelect<T>(with data: T)
}
