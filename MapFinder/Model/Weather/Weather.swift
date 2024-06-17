//
//  Weather.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation


struct WeatherResponse: Codable {
    let latitude: Double
    let longitude: Double
    let generationTimeMs: Double
    let utcOffsetSeconds: Int
    let timezone: String
    let timezoneAbbreviation: String
    let elevation: Double
    let hourlyUnits: HourlyUnits
    let hourly: Hourly
    
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, timezone, elevation, hourly
        case generationTimeMs = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezoneAbbreviation = "timezone_abbreviation"
        case hourlyUnits = "hourly_units"
    }
}

struct HourlyUnits: Codable {
    let time: String
    let temperature2m: String
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
    }
}

struct Hourly: Codable {
    let time: [String]
    let temperature2m: [Double]
    let precipitation_probability: [Int]
    let cloud_cover: [Int]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case precipitation_probability
        case cloud_cover
    }
}
