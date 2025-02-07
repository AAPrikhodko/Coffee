//
//  FullMapView2.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import MapKit

struct FullMapView2: View {
    @Binding var navigationPath: [LocationPickerRoute]
    @Binding var locationViewModel: LocationViewModel
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $mapCameraPosition) {
            if let location = locationViewModel.currentLocation {
                Marker("Curent Location", coordinate: location.coordinate)
                    .annotationTitles(.hidden)
            }
        }
        .ignoresSafeArea(edges: .all)
        .onAppear {
            if let location = locationViewModel.currentLocation {
                mapCameraPosition = .region(
                    MKCoordinateRegion(
                        center: CLLocationCoordinate2D(
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        ),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                )
            }
        }
    }
}

#Preview {
    FullMapView2(
        navigationPath: .constant([LocationPickerRoute]()),
        locationViewModel: .constant(LocationViewModel())
    )
}
