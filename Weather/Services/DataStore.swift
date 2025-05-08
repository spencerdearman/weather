//
//  DataStore.swift
//  Weather
//
//  Created by Spencer Dearman on 5/7/25.
//

import Foundation

@Observable
class DataStore {
    var forPreviews: Bool
    var cities: [City] = []
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            
        }
    }
}
