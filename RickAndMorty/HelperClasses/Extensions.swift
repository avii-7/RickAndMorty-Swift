//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Arun on 07/06/23.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach({
            addSubview($0)
        })
    }
}
