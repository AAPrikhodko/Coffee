//
//  FullMapView2.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import MapKit

struct FullMapView2: View {
    @Binding var navigationPath: [NewRecordRoute]
    @Binding var locationViewModel: LocationViewModel
    
    @State private var mapCameraPosition: MapCameraPosition = .automatic
    @State private var annotationScale: CGFloat = 0.5
    
    var body: some View {
        ZStack {
            Map(position: $mapCameraPosition)
            .onAppear {
                if let location = locationViewModel.currentLocation {
                  
                    mapCameraPosition = .region(
                        MKCoordinateRegion(
                            center: location.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                        )
                    )
                }
            }
            .onMapCameraChange(frequency: .onEnd) { context in
                locationViewModel.currentLocation = CLLocation(
                    latitude: context.camera.centerCoordinate.latitude,
                    longitude: context.camera.centerCoordinate.longitude
                )
            }
            
            VStack(spacing: 8) {
                if let address = locationViewModel.currentAddress {
                    Text(address)
                        .font(.caption)
                        .padding(6)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    // Optionally add a fade transition
                        .transition(.opacity)
                }
                
                Image(systemName: "mappin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                // Increase the frame size to make the annotation bigger.
                    .frame(width: 50, height: 50)
                    .foregroundColor(.red)
                    .shadow(radius: 3)
                // Animate the scaling effect.
                    .scaleEffect(annotationScale)
                    .onAppear {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)) {
                            annotationScale = 1.0
                        }
                    }
            }
        }
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button {
                    navigationPath.removeLast()
                } label: {
                    Text("Select")
                }
            }
        }
    }
}


#Preview {
    FullMapView2(
        navigationPath: .constant([NewRecordRoute]()),
        locationViewModel: .constant(LocationViewModel())
    )
}
