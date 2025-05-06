//
//  CitiesListView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI

struct CitiesListView: View {
    @Environment(\.dismiss) private var dismiss
    let currentLocation: City?
    @Binding var selectedCity: City?
    var body: some View {
        NavigationStack {
            List {
                if let currentLocation {
                    Text(currentLocation.name)
                        .onTapGesture {
                            selectedCity = currentLocation
                            dismiss()
                        }
                }
                ForEach(City.cities) { city in
                    Text(city.name)
                        .onTapGesture {
                            selectedCity = city
                            dismiss()
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            // think about the preferred color scheme
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
}
