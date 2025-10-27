//
//  Utilities.swift
//  RickAndMorty
//
//  Created by Avii 🔥 on 26/10/25.
//

let ErrorIdentifier: String = "ErrorIdentifier"

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
