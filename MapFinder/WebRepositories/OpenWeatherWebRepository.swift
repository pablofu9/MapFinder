//
//  OpenWeatherWebRepository.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation

protocol OpenWeatherWebRepository: WebRepository {
    
    func getWeatherInfo(lat: Double, longitud: Double, startDate: String, endDate: String) async throws -> WeatherResponse
}

struct RealOpenWeatherWebRepository: OpenWeatherWebRepository {

    var session: URLSession
    @BaseURLSlashed private (set) var baseURL: String
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func getWeatherInfo(lat: Double, longitud: Double, startDate: String, endDate: String) async throws -> WeatherResponse {
        return try await call(endpoint: API.getWeatherInfo(lat: lat, longitud: longitud, startDate: startDate, endDate: endDate))
    }
}

struct MockOpenWeatherWebRepository: OpenWeatherWebRepository {

    
    /// The URLSession used for network requests.
    var session: URLSession = .mockedResponsesOnly
    
    /// The base URL for the mock API.
    var baseURL: String = "https://test.com"
    
    func getWeatherInfo(lat: Double, longitud: Double, startDate: String, endDate: String) async throws -> WeatherResponse {
        return WeatherResponse(latitude: 0, longitude: 0, generationTimeMs: 0, utcOffsetSeconds: 0, timezone: "", timezoneAbbreviation: "", elevation: 0, hourlyUnits: HourlyUnits(time: "", temperature2m: ""), hourly: Hourly(time: [], temperature2m: [], precipitation_probability: [], cloud_cover: []))
    }
}

extension RealOpenWeatherWebRepository {
    enum API {
        case getWeatherInfo(lat: Double, longitud: Double, startDate: String, endDate: String)
    }
}

extension RealOpenWeatherWebRepository.API: APICall {
    var path: String {
        switch self {
        case .getWeatherInfo(let lat, let longitud,let  startDate, let endDate):
            return "?latitude=\(lat)&longitude=\(longitud)&start_date=\(startDate)&end_date=\(endDate)&hourly=temperature_2m,precipitation_probability,cloud_cover"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getWeatherInfo:
            return .get
        }
    }
    
    var authenticated: Bool {
        switch self {
        case .getWeatherInfo:
            return false
        }
    }
    
    func headers() async throws -> [String : String]? {
        switch self {
        case .getWeatherInfo:
            return [:]
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .getWeatherInfo:
            return nil
        }
    }
    
    
}
