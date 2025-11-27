//
//  DataFormatterService.swift
//  PetProject
//
//  Created by user on 27.11.2025.
//

import Foundation

enum DateFormatterService {
    
    //"2025-11-26T00:00"
    private static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()
    
    private static let outputTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()
    
    private static let outputTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()
    
    static func formatedHour(from timeString: String) -> String {
        guard let date = inputFormatter.date(from: timeString) else {
            return timeString
        }
        return outputTimeFormatter.string(from: date)
    }
    
    static func formatedDate(from dateString: String) -> String {
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        return outputTimeDateFormatter.string(from: date)
    }
    
}
