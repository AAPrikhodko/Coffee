//
//  FullMapView.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI
import MapKit

struct FullMapView: View {
    @Binding var newRecordState: NewRecordState
    var recordViewModel: NewRecordViewModel
    var mapView: MKMapView
    
    @State private var showLocationDetails: Bool
    
    init(newRecordState: Binding<NewRecordState>, recordViewModel: NewRecordViewModel, mapView: MKMapView) {
        self._newRecordState = newRecordState
        self.recordViewModel = recordViewModel
        self.mapView = mapView
        
        // ✅ Initialize @State using the current ViewModel value
        _showLocationDetails = State(initialValue: recordViewModel.record.place.location != nil)
    }
    
    var body: some View {
        if (newRecordState == .fullMap) {
            ZStack(alignment: .top) {
                MapViewRepresentable(mapView: mapView, recordViewModel: recordViewModel)
                    .ignoresSafeArea()
                    .background(.white)
                
                LocationSearchActivationButton()
                    .padding(.top, 4)
                    .onTapGesture {
                        newRecordState = .searchLocations
                    }
                
                HStack {
                    CancelButton()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                newRecordState = .collectingData
                            }
                        }
                    SelectButton()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                newRecordState = .collectingData
                            }
                        }
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        } else if (newRecordState == .searchLocations){
            LocationSearchView()
        }
    }
}

#Preview {
    FullMapView(newRecordState: .constant(.fullMap), recordViewModel: NewRecordViewModel(), mapView: MKMapView())
        .environmentObject(LocationSearchViewModel())
}
