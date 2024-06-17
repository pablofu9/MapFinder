//
//  WeatherDetail.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 17/6/24.
//

import SwiftUI
import Lottie

enum WeatherType: String {
    case sunny = "sunIcon"
    case cloudy = "cloudIcon"
    case rainy = "rainIcon"
}


struct WeatherDetail: View {
    
    @Environment(\.dismiss) var dismiss
    var weatherResponse: WeatherResponse
    var place: Place
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                currentHour
              
                scrollHours
                   
  
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    goBackButton
                }
            }
            .navigationTitle("Weather detail")
        }
    }
    
    // MARK: - Subviews
    /// Logo icon
    @ViewBuilder
    private var LottieIcon: some View {
        LottieView(animation: .named("SunRain"))
          .playing(loopMode: .loop)
          .opacity(0.5)

    }
    
    @ViewBuilder
    private var currentHour: some View {
        let hours = DateTimerManager.formatHours(from: weatherResponse.hourly.time)
        let selectedHourIndex = DateTimerManager.getCurrentHourIndex(hours: hours)
        let safeIndex = selectedHourIndex ?? 0
        let selectedHour = hours[safeIndex]
        let temperature = weatherResponse.hourly.temperature2m[safeIndex].rounded()
        ZStack {
            LottieIcon
            
            VStack(spacing: 5) {
                Text(place.placemark.administrativeArea ?? "")
                    .font(.title)
                    .foregroundStyle(Color.black)
                Text(selectedHour)
                    .font(.title2)
                    .foregroundStyle(Color.black)
                    .fontWidth(.condensed)
                Text("\(Int(temperature))°C")
                    .font(.title)
                    .fontWeight(.bold)
                    .fontWidth(.standard)
                    .foregroundStyle(Color.black)
                
            }
        }
    }
    
    /// Go back button
    @ViewBuilder
    private var goBackButton: some View {
        Button {
            withAnimation(.interactiveSpring(duration: 0.5, extraBounce: 2)) {
                dismiss()
            }
        } label: {
            HStack {
                Image(systemName: "arrow.left")
                    .renderingMode(.template)
                    .foregroundStyle(.black.opacity(0.8))
                Text("Return")
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.opacity(0.6))
            }
        }
    }
    
    @ViewBuilder
    private var scrollHours: some View {
        List {
            VStack(alignment: .leading,spacing: 10) {
                let hours = DateTimerManager.formatHours(from: weatherResponse.hourly.time)
                let selectedHourIndex = DateTimerManager.getCurrentHourIndex(hours: hours)
                
                if let startIndex = selectedHourIndex {
                    let sortedHours = Array(weatherResponse.hourly.time[startIndex ..< weatherResponse.hourly.time.count])
                    let sortedPrecipitacion = Array(weatherResponse.hourly.precipitation_probability[startIndex ..< weatherResponse.hourly.time.count])
                    let sortedClouds = Array(weatherResponse.hourly.cloud_cover[startIndex ..< weatherResponse.hourly.time.count])
                    let sortedTemperatures = Array(weatherResponse.hourly.temperature2m[startIndex ..< weatherResponse.hourly.temperature2m.count])
                    Section {
                        ForEach(sortedHours.indices, id: \.self) { index in
                            if sortedPrecipitacion[index] < 10 {
                                if sortedClouds[index] < 50 {
                                    renderHourlyView(time: sortedHours[index], temperature: sortedTemperatures[index], weatherType: .sunny)
                                } else {
                                    renderHourlyView(time: sortedHours[index], temperature: sortedTemperatures[index], weatherType: .cloudy)
                                }
                            } else {
                                renderHourlyView(time: sortedHours[index], temperature: sortedTemperatures[index], weatherType: .rainy, precipitation: sortedPrecipitacion[index])
                            }
                        }
                    } header: {
                        Text("Weather today")
                            .foregroundStyle(.black.opacity(0.5))
                            .headerProminence(.increased)
                    }
                   
                 
                }
            }
            
        }
        .listStyle(.inset)
        .scrollContentBackground(.hidden)
        .background(Color.clear.opacity(0.5).edgesIgnoringSafeArea(.all))
        .frame(maxWidth: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private func renderHourlyView(time: String, temperature: Double, weatherType: WeatherType, precipitation: Int? = nil) -> some View {
        HStack {
            let timeFormatted = DateTimerManager.formatTime(from: time)
            let roundedTemperature = temperature.rounded()
            
            Text("\(timeFormatted ?? "")")
            Divider()
                .frame(width: 2)
                .background(.black.opacity(0.3))
            Spacer()
            VStack(spacing: 5) {
                Image(weatherType.rawValue)
                if let precipitation = precipitation {
                    Text("\(precipitation)%")
                        .foregroundStyle(.blue)
                }
            }
           Spacer()
            Text("\(Int(roundedTemperature))°C")
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 30)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.1))
        }
        .padding(.horizontal, 6)
    }
}

#Preview {
    let response = generateMockWeatherResponses()
    let place = generateMockPlaces().first!
    return WeatherDetail(weatherResponse: response, place: place)
}
