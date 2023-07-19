//
//  SelectionProtocol.swift
//  RickAndMorty
//
//  Created by Arun on 18/07/23.
//

import Foundation

protocol SelectionDelegate: AnyObject {
    func didSelect<T>(with model: T)
}
