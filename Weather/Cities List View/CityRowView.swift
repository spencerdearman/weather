//
//  CityRowView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI
import WeatherKit

struct CityRowView: View {
    let weatherManager = WeatherManager.shared
    @Environment(LocationManager.self) var locationManager
    @State private var currentWeather: CurrentWeather?
    @State private var timezone: TimeZone = .current
    @State private var hourlyForecast: Forecast<HourWeather>?
    @State private var isLoading = false
    let city: City
    
    var highTemperature: String? {
        if let high = hourlyForecast?.map({$0.temperature}).max() {
            return weatherManager.temperatureFormatter.string(from: high)
        } else {
            return nil
        }
    }
    
    var lowTemperature: String? {
        if let low = hourlyForecast?.map({$0.temperature}).min() {
            return weatherManager.temperatureFormatter.string(from: low)
        } else {
            return nil
        }
    }
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                if let currentWeather {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(city.name)
                                    .font(.system(size: 20, weight: .bold, design: .default))
                                    .preferredColorScheme(.dark)
                                    .lineLimit(1)
                                Text(currentWeather.date.localTime(for: timezone))
                                    .font(.caption)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            let temp = weatherManager.temperatureFormatter.string(from: currentWeather.temperature)
                            Text(removeUnits(temp))
                                .font(.system(size: 40, weight: .regular, design: .default))
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        HStack {
                            Text(currentWeather.condition.description)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .preferredColorScheme(.dark)
                            Spacer()
                            if let lowTemperature, let highTemperature {
                                Text("H:\(removeUnits(highTemperature))  L:\(removeUnits(lowTemperature))")
                                    .font(.caption)
                                    .bold()
                                    .preferredColorScheme(.dark)
                            }
                            
                        }
                    }
                    .padding([.top, .bottom], 10)
                    .padding([.leading, .trailing], 15)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background {
            if let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
            }
        }
        .task(id: city) {
            await fetchWeather(for: city)
        }
    }
    
    func removeUnits(_ string: String) -> String {
        return string.filter { $0 != "F" && $0 != "C" }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
        }
        isLoading = false
    }
}

#Preview {
    CityRowView(city: City.mockCurrent)
        .environment(LocationManager())
}
