//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Arun on 07/06/23.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

extension String {
    static let empty = "" 
}

extension UIDevice {
    static let isIphone: Bool = UIDevice.current.userInterfaceIdiom == .phone
}
