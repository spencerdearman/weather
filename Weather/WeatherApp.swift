//
//  WeatherApp.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI

@main
struct WeatherApp: App {
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
    }
}
