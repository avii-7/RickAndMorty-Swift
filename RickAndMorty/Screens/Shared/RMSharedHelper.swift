//
//  RMSharedHelper.swift
//  RickAndMorty
//
//  Created by Arun on 08/02/24.
//

import UIKit

struct RMSharedHelper {
    static func getIndexPaths(start: Int, end: Int) -> [IndexPath] {
        Array(start...end).compactMap {
            IndexPath(row: $0, section: 0)
        }
    }
    
    static var randomColor: UIColor {
        let red = CGFloat.random(in: 0...1)
        let green = CGFloat.random(in: 0...1)
        let blue = CGFloat.random(in: 0...1)
        
        return UIColor(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }
}


