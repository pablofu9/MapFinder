//
//  DateTimerManager.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation

struct DateTimerManager {
    static let shared = DateTimerManager()
    
    static func getCurrentDate() -> String {
        let today = Date()
        return formatDate(today)
    }
    
    static func getTomorrowDate() -> String {
        let today = Date()
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today) else {
            return formatDate(today)
        }
        return formatDate(tomorrow)
    }
    
    private static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: date)
    }
}
