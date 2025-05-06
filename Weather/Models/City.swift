//
//  City.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import Foundation
import CoreLocation

struct City: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    static var cities: [City] {
        [
            .init(name: "Paris, France", latitude: 48.856788, longitude: 2.351077),
            .init(name: "Syndey, Australia", latitude: -33.872710, longitude: 151.205694),
            .init(name: "New York, USA", latitude: 40.712820, longitude: -74.006010),
            .init(name: "Tokyo, Japan", latitude: 35.689500, longitude: 139.691706),
        ]
    }
    
    static var mockCurrent: City {
        .init(name: "Chicago", latitude: 41.883718, longitude: -87.632382 )
    }
}
