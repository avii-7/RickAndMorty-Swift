//
//  Utilities.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 26/10/25.
//
import Foundation

let ErrorIdentifier: String = "ErrorIdentifier"

let ScreenEdgesHorizontalPadding: CGFloat = 16.0

let SectionsVerticalPadding: CGFloat = 16.0

func printError(_ error: Error) {
#if DEBUG
    print(error.localizedDescription, error, ErrorIdentifier, separator: " - ")
#endif
}

func printError(_ error: String) {
#if DEBUG
    print(error, ErrorIdentifier, separator: " - ")
#endif
}
