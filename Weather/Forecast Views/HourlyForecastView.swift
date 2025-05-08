//
//  HourlyForecastView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/7/25.
//

import SwiftUI
import WeatherKit

struct HourlyForecastView: View {
    let weatherManager = WeatherManager.shared
    let hourlyForecast: Forecast<HourWeather>
    let timezone: TimeZone
    var body: some View {
        VStack {
            if let currentHour = hourlyForecast.first {
                Text("\(currentHour.condition.description) now with a high of \(weatherManager.temperatureFormatter.string(from: currentHour.temperature))")
                    .font(.caption).bold()
                    .padding(.top, 10)
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
                            .frame(maxHeight: 30)
                            Text(removeUnits(weatherManager.temperatureFormatter.string(from: hour.temperature)))
                        }
                    }
                }
                .font(.system(size: 13))
                .frame(height: 60)
            }
            .contentMargins(.all, 20, for: .scrollContent)
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.secondary.opacity(0.2)))
    }
    
    func removeUnits(_ string: String) -> String {
        return string.filter { $0 != "F" && $0 != "C" }
    }
}

//#Preview {
//    HourlyForecastView()
//}
