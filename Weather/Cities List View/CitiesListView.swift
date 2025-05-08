//
//  CitiesListView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI
import MapKit

struct CitiesListView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataStore.self) private var store
    let currentLocation: City?
    @Binding var selectedCity: City?
    @State private var searchText = ""
    @State private var searchService = SearchService(completer: MKLocalSearchCompleter())
    
    var filteredCities: [City] {
        if searchText.isEmpty {
            return store.cities
        } else {
            return store.cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Group {
                    if let currentLocation {
                        CityRowView(city: currentLocation)
                            .onTapGesture {
                                selectedCity = currentLocation
                                dismiss()
                            }
                    }
                    
                    ForEach(filteredCities.sorted(using: KeyPathComparator(\.name))) { city in
                        CityRowView(city: city)
                            .swipeActions {
                                Button(role: .destructive) {
                                    if let index = store.cities.firstIndex(where: {$0.id == city.id}) {
                                        store.cities.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                            .onTapGesture {
                                selectedCity = city
                                dismiss()
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .listRowInsets(.init(top: 0, leading: 20, bottom: 5, trailing: 20))
            }
            .listStyle(.plain)
            .navigationTitle("My Cities")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(.dark)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic)) {
                ForEach(searchService.cities) { city in
                    Button {
                        if !store.cities.contains(where: { $0.name == city.name }) {
                            store.cities.append(city)
                        }
                        searchText = ""
                    } label: {
                        Text("Add “\(city.name)”")
                    }
                }
            }
            .onChange(of: searchText) {
                searchService.update(queryFragment: searchText)
            }
        }
    }
}

#Preview {
    CitiesListView(currentLocation: City.mockCurrent, selectedCity: .constant(nil))
        .environment(LocationManager())
        .environment(DataStore(forPreviews: true))
}
