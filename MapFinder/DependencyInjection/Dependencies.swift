//
//  Dependencies.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation
//
//  Dependencies.swift
//  FMTempo
//
//  Created by Pablo Fuertes on 8/5/24.
//

import Foundation

class Dependencies {
    
    static var shared: Dependencies = .init()
    
    var session: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.urlCache = .shared
        
        return URLSession(configuration: configuration)
    }
    
    
    /// Function that provides the dependencies on app init
    func provideDependencies(testMode: Bool = false) {
        getWeatherDependency(testMode: testMode)
    }
}

// MARK: - Bus Stop Arrival time
extension Dependencies {
    private func getWeatherDependency(testMode: Bool = false) {
        if testMode {
            @Provider var weatherWebRepo = MockOpenWeatherWebRepository() as OpenWeatherWebRepository
        } else {
            
            let baseUrl: String = "https://historical-forecast-api.open-meteo.com/v1/forecast"
            
            @Provider var weatherWebRepo = RealOpenWeatherWebRepository(session: session, baseURL: baseUrl) as OpenWeatherWebRepository
           
        }
    }
}


