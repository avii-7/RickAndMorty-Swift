//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Arun on 07/06/23.
//

import UIKit

extension UIView {
    
    /// Append views to the receiver's list of subviews.
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}

extension String {
    static var empty = "" 
}

extension Array {
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

extension UIDevice {
    static let isIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}
