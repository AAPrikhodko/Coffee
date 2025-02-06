//
//  LocationPickerView.swift
//  Coffee
//
//  Created by Andrei on 05.02.2025.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @State private var navigationPath = [LocationPickerRoute]()
    @State private var locationViewModel = LocationViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            PreviewMapView(navigationPath: $navigationPath)
                .navigationDestination(for: LocationPickerRoute.self) { route in
                    switch (route) {
                    case .previewMap:
                        PreviewMapView(navigationPath: $navigationPath)
                    case .fullMap:
                        FullMapView2(navigationPath: $navigationPath)
                    case .searchLocations:
                        SearchLocationsView(navigationPath: $navigationPath)
                    }
                }
        }
    }
}

#Preview {
    LocationPickerView()
}
