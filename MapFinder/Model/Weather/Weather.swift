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

func generateMockWeatherResponses() -> WeatherResponse {
    let mockWeatherResponses: WeatherResponse = (
        WeatherResponse(
            latitude: 41.64,
            longitude: -4.73,
            generationTimeMs: 0.26607513427734375,
            utcOffsetSeconds: 0,
            timezone: "GMT",
            timezoneAbbreviation: "GMT",
            elevation: 694.0,
            hourlyUnits: HourlyUnits(time: "iso8601", temperature2m: "°C"),
            hourly: Hourly(
                time: [
                    "2024-06-17T00:00", "2024-06-17T01:00", "2024-06-17T02:00", "2024-06-17T03:00",
                    "2024-06-17T04:00", "2024-06-17T05:00", "2024-06-17T06:00", "2024-06-17T07:00",
                    "2024-06-17T08:00", "2024-06-17T09:00", "2024-06-17T10:00", "2024-06-17T11:00",
                    "2024-06-17T12:00", "2024-06-17T13:00", "2024-06-17T14:00", "2024-06-17T15:00",
                    "2024-06-17T16:00", "2024-06-17T17:00", "2024-06-17T18:00", "2024-06-17T19:00",
                    "2024-06-17T20:00", "2024-06-17T21:00", "2024-06-17T22:00", "2024-06-17T23:00"
                ],
                temperature2m: [
                    17.7, 16.8, 15.8, 15.1, 14.3, 13.4, 13.8, 15.2, 17.1, 19.5, 21.5, 23.7,
                    25.4, 26.9, 28.0, 28.8, 29.2, 28.6, 27.5, 26.3, 25.3, 24.5, 22.1, 19.9
                ],
                precipitation_probability: [
                    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 10, 16, 23, 23, 23
                ],
                cloud_cover: [
                    0, 0, 0, 0, 0, 0, 0, 0, 49, 100, 100, 100, 23, 20, 100, 100, 79, 100, 100,
                    100, 100, 100, 100, 100
                ]
            )
        )
    )
    
    return mockWeatherResponses
}
