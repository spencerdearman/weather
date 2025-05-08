//
//  DailyForecastView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI
import WeatherKit
import CoreLocation

struct ForecastView: View {
    @Environment(LocationManager.self) var locationManager
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedCity: City?
    let weatherManager = WeatherManager.shared
    @State private var currentWeather: CurrentWeather?
    @State private var hourlyForecast: Forecast<HourWeather>?
    @State private var dailyForecast: Forecast<DayWeather>?
    @State private var isLoading = false
    @State private var showCityList = false
    @State private var timezone: TimeZone = .current
    
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
        ScrollView {
            VStack {
                if let selectedCity {
                    if isLoading {
                        ProgressView()
                        Text("Fetching Weather...")
                    } else {
                        Text(selectedCity.name)
                            .font(.title)
                        if let currentWeather {
                            CurrentWeatherView(
                                currentWeather: currentWeather,
                                highTemperature: highTemperature,
                                lowTemperature: lowTemperature,
                                timezone: timezone
                            )
                        }
                        Divider()
                        if let hourlyForecast {
                            // ------
                            // UNCOMMENT ONCE YOU ARE DONE EDITING, BUT THIS NEEDS WORK AND I WANT TO USE LIVE PREVIEWS
//                            HourlyForecastView(
//                                hourlyForecast: hourlyForecast,
//                                timezone: timezone
//                            )
                            // ------
                            
                            Text("Hourly Forecast").font(.title)
                            Text("Next 25 hours").font(.caption)
                            VStack {
                                if let currentHour = hourlyForecast.first {
                                    Text(weatherManager.temperatureFormatter.string(from: currentHour.temperature))
                                    Text(currentHour.condition.description)
                                    Divider()
                                }
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 22) {
                                        ForEach(hourlyForecast, id: \.date) { hour in
                                            VStack(spacing: 10) {
                                                HStack(alignment: .bottom, spacing: 0) {
                                                    Text(hour.date.hourlyTime(for: timezone))
                                                        .font(.caption).bold()
                                                    Text(hour.date.amPmTime(for: timezone))
                                                        .font(.caption2).bold()
                                                }
                                                Spacer()
                                                Group {
                                                    Image(systemName: hour.symbolName)
                                                        .renderingMode(.original)
                                                        .symbolVariant(.fill)
                                                        .font(.system(size: 22))
                                                        .padding(.bottom,3)
                                                    if hour.precipitationChance > 0 {
                                                        Text("\((hour.precipitationChance * 100).formatted(.number.precision(.fractionLength(0))))%")
                                                            .foregroundStyle(.cyan)
                                                            .bold()
                                                    }
                                                }
                                                Spacer()
                                                Text(removeUnits(weatherManager.temperatureFormatter.string(from: hour.temperature)))
                                            }
                                        }
                                    }
                                    .font(.system(size: 13))
                                    .frame(height: 100)
                                }
                                .contentMargins(.all, 20, for: .scrollContent)
                            }
                            .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.2)))
                            
                            // -----
                            
                        }
                        Divider()
                        if let dailyForecast {
                            DailyForecastView(dailyForecast: dailyForecast, timezone: timezone)
                        }
                        AttributionView()
                            .tint(.white)
                    }
                }
            }
        }
        .contentMargins(.all, 15, for: .scrollContent)
        .background {
            if selectedCity != nil,
               let condition = currentWeather?.condition {
                BackgroundView(condition: condition)
            }
        }
        .preferredColorScheme(.dark)
        .safeAreaInset(edge: .bottom) {
            Button {
                showCityList.toggle()
            } label: {
                Image(systemName: "list.star")
            }
            .padding()
            .background(Color(.darkGray))
            .clipShape(.circle)
            .foregroundStyle(.white)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .fullScreenCover(isPresented: $showCityList) {
            CitiesListView(currentLocation: locationManager.currentLocation, selectedCity: $selectedCity)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                selectedCity = locationManager.currentLocation
                if let selectedCity {
                    Task {
                        await fetchWeather(for: selectedCity)
                    }
                }
            }
        }
        .task(id: locationManager.currentLocation) {
            if let currentLocation = locationManager.currentLocation, selectedCity == nil {
                selectedCity = currentLocation
            }
        }
        
        .task(id: selectedCity) {
            if let selectedCity {
                await fetchWeather(for: selectedCity)
            }
        }
    }
    
    func fetchWeather(for city: City) async {
        isLoading = true
        Task.detached { @MainActor in
            currentWeather = await weatherManager.currentWeather(for: city.clLocation)
            timezone = await locationManager.getTimezone(for: city.clLocation)
            hourlyForecast = await weatherManager.hourlyForecast(for: city.clLocation)
            dailyForecast = await weatherManager.dailyForecast(for: city.clLocation)
        }
        isLoading = false
    }
    
    func forecastString(condition: String, temperature: Measurement<UnitTemperature>) -> String {

        let tempFormatter = MeasurementFormatter()
        tempFormatter.unitOptions = .providedUnit
        tempFormatter.numberFormatter.maximumFractionDigits = 0
        let tempString = tempFormatter.string(from: temperature)

        return "\(condition) expected today, with a high of \(tempString)."
    }
    
    // REMOVE THIS THIS IS TEMP HERE
    func removeUnits(_ string: String) -> String {
        return string.filter { $0 != "F" && $0 != "C" }
    }
}

#Preview {
    ForecastView()
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
}
