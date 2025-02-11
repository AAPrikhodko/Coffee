//
//  PreviewMapView.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import MapKit

struct PreviewMapView: View {
    @Binding var navigationPath: [NewRecordRoute]
    @Binding var locationViewModel: LocationViewModel
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $mapCameraPosition, interactionModes: []) {
            if (locationViewModel.currentLocation != nil) {
                Marker("Curent Location", coordinate: locationViewModel.currentLocation!.coordinate)
                    .annotationTitles(.hidden)
            }
        }
        .frame(height: 200)
        .onChange(of: locationViewModel.currentLocation, {
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
            
        })
        .frame(height: 200)
        .onTapGesture {
            withAnimation(.spring()) {
                navigationPath.append(.mapPicker)
            }
        }
    }
    
}


#Preview {
    PreviewMapView(
        navigationPath: .constant([NewRecordRoute]()),
        locationViewModel: .constant(LocationViewModel())
    )
}
