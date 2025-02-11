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
    
    @State private var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $mapCameraPosition, interactionModes: []) {
            if (locationViewModel.isAuthorized) {
                Marker("Curent Location", coordinate: locationViewModel.location.coordinate)
                    .annotationTitles(.hidden)
            }
        }
        .onChange(of: locationViewModel.location) {
            updateMapCameraPosition()
        }
        .frame(height: 200)
        .onTapGesture {
            withAnimation(.spring()) {
                navigationPath.append(.mapPicker)
            }
        }
    }
    
    func updateMapCameraPosition() {
        let spanDelta = locationViewModel.isAuthorized ? 0.002 : 180
        let region: MKCoordinateRegion =
                MKCoordinateRegion(
                    center: locationViewModel.location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: spanDelta, longitudeDelta: 2*spanDelta)
                )
        withAnimation {
            mapCameraPosition = .region(region)
        }
    }
    
}


#Preview {
    PreviewMapView(
        navigationPath: .constant([NewRecordRoute]()),
        locationViewModel: .constant(LocationViewModel())
    )
}
