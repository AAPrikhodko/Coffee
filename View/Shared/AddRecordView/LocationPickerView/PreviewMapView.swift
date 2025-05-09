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
    
    var body: some View {
        Map(position: $locationViewModel.mapCameraPosition, interactionModes: []) {
            if (locationViewModel.isAuthorized) {
                Marker("Curent Location", coordinate: locationViewModel.coordinates.asCLLocationCoordinate2D)
                    .annotationTitles(.hidden)
            }
        }
        .frame(height: 200)
        .onTapGesture {
            withAnimation(.spring()) {
                navigationPath.append(.mapPicker)
            }
        }
    }
    
}


//#Preview {
//    PreviewMapView(
//        navigationPath: .constant([NewRecordRoute]()),
//        locationViewModel: .constant(LocationViewModel())
////        locationPickerViewModel: .constant(LocationPickerViewModel())
//    )
//}
