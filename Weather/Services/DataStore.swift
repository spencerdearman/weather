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
    let filemanager = FileManager()
    
    init(forPreviews: Bool = false) {
        self.forPreviews = forPreviews
        loadCities()
    }
    
    func loadCities() {
        if forPreviews {
            cities = City.cities
        } else {
            if filemanager.fileExists() {
                do {
                    let data = try filemanager.readFile()
                    cities = try JSONDecoder().decode([City].self, from: data)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func saveCities() {
        if !forPreviews {
            do {
                let data = try JSONEncoder().encode(cities)
                let jsonString = String(decoding: data, as: UTF8.self)
                try filemanager.saveFile(contents: jsonString)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
