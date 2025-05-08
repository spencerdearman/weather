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
    @State private var store = DataStore()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ForecastView()
                    .onAppear {
                        print(URL.documentsDirectory.path())
                    }
            } else {
                LocationDeniedView()
            }
        }
        .environment(locationManager)
        .environment(store)
    }
}
