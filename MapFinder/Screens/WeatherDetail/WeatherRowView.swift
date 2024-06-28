//
//  WeatherRowView.swift
//  MapFinder
//
//  Created by Pablo Fuertes on 28/6/24.
//

import SwiftUI

struct WeatherRowView: View {
    let time: String
    let temperature: Double
    let weatherType: WeatherType
    let precipitation: Int?
    
    // MARK: - Body
    var body: some View {
        content     
    }
}

extension WeatherRowView {
    
    @ViewBuilder
    private var precipitationView: some View {
        VStack(spacing: 5) {
            Image(weatherType.rawValue)
            if let precipitation = precipitation {
                Text("\(precipitation)%")
                    .foregroundStyle(.blue)
            }
        }
    }
    
    @ViewBuilder
    private var headerView: some View {
        let timeFormatted = DateTimerManager.formatTime(from: time)
        Text("\(timeFormatted ?? "")")
        Divider()
            .frame(width: 2, height: 50)
            .background(.black.opacity(0.5))
    }
    
    @ViewBuilder
    private var content: some View {
        let roundedTemperature = temperature.rounded()

    ZStack {
        HStack(spacing: 20) {
            headerView
            Spacer()
            precipitationView
            Spacer()
            Text("\(Int(roundedTemperature))°C")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
       
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .background(LinearGradient(colors: [.gray.opacity(0.2), .black.opacity(0.3)], startPoint: .top, endPoint: .bottom))
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .padding(.horizontal, 20)
    }
}

#Preview {
    WeatherRowView(time: "2024-06-17T00:00", temperature: 25, weatherType: .cloudy, precipitation: 0)
}
