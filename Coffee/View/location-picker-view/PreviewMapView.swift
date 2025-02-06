//
//  PreviewMapView.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import MapKit

struct PreviewMapView: View {
    @Binding var navigationPath: [LocationPickerRoute]
    @Binding var locationViewModel: LocationViewModel
    
    // Default region (e.g., centered on a generic location like Earth's center)
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
        )
    )
    
    var body: some View {
        Map(position: $mapCameraPosition)
            .frame(height: 200)
            .onChange(of: locationViewModel.currentLocation) { _, location in
                let center = CLLocationCoordinate2D(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center: center, span: span)
                mapCameraPosition = .region(region)
            }
            .onTapGesture {
                withAnimation(.spring()) {
                    navigationPath.append(.fullMap)
                }
            }
    }
}

#Preview {
    PreviewMapView(
        navigationPath: .constant([LocationPickerRoute]()),
        locationViewModel: .constant(LocationViewModel())
    )
}
