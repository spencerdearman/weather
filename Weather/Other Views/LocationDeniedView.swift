//
//  LocationDeniedView.swift
//  Weather
//
//  Created by Spencer Dearman on 5/6/25.
//

import SwiftUI

struct LocationDeniedView: View {
    var body: some View {
        
        ContentUnavailableView(label: {
            Label("Location Services", systemImage: "gear")
        }, description: {
            Text("""
                Please update Location Services in Privacy and Security settings
                """)
        }, actions: {
            Button(action: {
                UIApplication.shared.open(
                    URL(string: UIApplication.openSettingsURLString)!,
                    options: [:],
                    completionHandler: nil
                )
            }) {
                Text("Open Settings")
            }.buttonStyle(.borderedProminent)
        })
    }
}

#Preview {
    LocationDeniedView()
}
