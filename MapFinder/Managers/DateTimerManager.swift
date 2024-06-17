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
    
    static func formatTime(from dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm"
        
        if let date = dateFormatter.date(from: dateString) {
            return formatTime(date)
        } else {
            return nil
        }
    }
    
    private static func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getCurrentHour() -> String {
           let today = Date()
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "HH:mm"
           return dateFormatter.string(from: today)
       }
       
       // Obtiene el índice de la hora actual dentro de un array de horas
    static func getCurrentHourIndex(hours: [String]) -> Int? {
        let currentHour = getCurrentHour()
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "HH:mm"
        
        guard let currentDate = hourFormatter.date(from: currentHour) else {
            return nil
        }
        
        // Redondear la hora actual hacia abajo al rango más cercano
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: currentDate)
        guard let hour = components.hour else {
            return nil
        }
        
        // Formatear las horas del array para comparar
        let formattedHours = hours.map { hourFormatter.date(from: $0) ?? Date() }
        
        // Encontrar el índice de la hora actual dentro del array
        for (index, formattedHour) in formattedHours.enumerated() {
            if hourFormatter.string(from: formattedHour) == hourFormatter.string(from: currentDate) {
                return index
            } else if formattedHour > currentDate {
                return index > 0 ? index - 1 : index
            }
        }
        
        return nil
    }

    
    static func formatHours(from dates: [String]) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        return dates.compactMap { dateString in
            if let date = dateFormatter.date(from: dateString) {
                let hourFormatter = DateFormatter()
                hourFormatter.dateFormat = "HH:mm"
                return hourFormatter.string(from: date)
            } else {
                return nil
            }
        }
    }
}
