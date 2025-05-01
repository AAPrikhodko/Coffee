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
    @Binding var locationPickerViewModel: LocationPickerViewModel
    
    @State private var annotationScale: CGFloat = 0.5
     
    var body: some View {
        ZStack {
            Map(position: $locationPickerViewModel.mapCameraPosition)
                .onMapCameraChange(frequency: .onEnd ) { context in
                    locationPickerViewModel.selectedLocation = CLLocation(
                        latitude: context.camera.centerCoordinate.latitude,
                        longitude: context.camera.centerCoordinate.longitude
                    )
                }
            
            VStack(spacing: 8) {
                
                Text(locationPickerViewModel.selectedLocationAddress)
                    .font(.caption)
                    .padding(6)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .shadow(radius: 2)
                // Optionally add a fade transition
                    .transition(.opacity)
                
                
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
            
            VStack {
                Spacer()
                
                HStack {
                    Button {
                        navigationPath.append(.searchLocation)
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.blue)
                            .font(.body)
                            .frame(width: 48, height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    Button {
                        locationPickerViewModel.setUserLocation()
                    } label: {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.blue)
                            .font(.body)
                            .frame(width: 48, height: 48)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem (placement: .topBarTrailing) {
                Button {
                    updateCoordinatesInViewModel()
                    navigationPath.removeLast()
                } label: {
                    Text("Select")
                }
            }
        }
    }
    
    func updateCoordinatesInViewModel() {
        locationViewModel.coordinates = Coordinates(from: locationPickerViewModel.selectedLocation.coordinate)
    }
}


#Preview {
    FullMapView2(
        navigationPath: .constant([NewRecordRoute]()),
        locationViewModel: .constant(LocationViewModel()),
        locationPickerViewModel: .constant(LocationPickerViewModel())
    )
}
