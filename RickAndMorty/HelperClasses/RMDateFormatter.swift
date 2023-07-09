//
//  DateFormatter.swift
//  RickAndMorty
//
//  Created by Arun on 09/07/23.
//

import Foundation

struct RMDateFormatter {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static func getFormattedDate(for dateValue: String) -> String {
        guard let date = dateFormatter.date(from: dateValue) else { return dateValue }
        let formattedDate = date.formatted(date: .abbreviated, time: .shortened)
        return formattedDate
    }
}
