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
    
    @State private var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 90, longitudeDelta: 180)
        )
    )
    
    var body: some View {
        Map(position: $mapCameraPosition)
            .frame(height: 200)
            .onChange(of: locationViewModel.currentLocationRegion) { _, equatableRegion in
                mapCameraPosition = .region(equatableRegion.mkRegion)
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
