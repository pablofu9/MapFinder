//
//  WeatherManager.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import Foundation
import OpenMeteoSdk
import MapKit

@MainActor
class WeatherManager: ObservableObject {
    
    @Published var loading: Bool = false
    
    func getWeather(coordinates: CLLocationCoordinate2D) async throws {
        @Inject var weatherRepo: OpenWeatherWebRepository
        loading = true
        do {
            let _ = try await weatherRepo.getWeatherInfo(lat: coordinates.latitude, longitud: coordinates.longitude, startDate: DateTimerManager.getCurrentDate(), endDate: DateTimerManager.getCurrentDate())
        } catch {
            print(error)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loading = false
        }
    }
}
