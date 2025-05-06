//
//  Forecast.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

// 21.277218, -157.829046
import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                Text("Fetching Weather...")
            } else {
                if let currentWeather {
                    Text(Date.now.formatted(date: .abbreviated, time: .omitted))
                    Text(Date.now.formatted(date: .omitted, time: .shortened))
                    Image(systemName: currentWeather.symbolName)
                        .symbolVariant(.fill)
                        .font(.system(size: 60.0, weight: .bold))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.secondary.opacity(0.2))
                        )
                    let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                    Text(temp)
                        .font(.title2)
                    Text(currentWeather.condition.description)
                        .font(.title3)
                    AttributionView()
                    
                }
            }
        }
        .padding()
        .task {
            isLoading = true
            Task.detached { @MainActor in
                currentWeather = await weatherManager.currentWeather(for: CLLocation(latitude: 21.277218, longitude: -157.829046))
                
            }
            isLoading = false
        }
    }
}

#Preview {
    ForecastView()
}
