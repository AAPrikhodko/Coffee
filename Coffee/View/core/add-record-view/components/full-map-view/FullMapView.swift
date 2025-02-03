//
//  FullMapView.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI

struct FullMapView: View {
    @Binding var newRecordState: NewRecordState
    
    var body: some View {
        if (newRecordState == .fullMap) {
            ZStack(alignment: .top) {
                MapViewRepresentable()
                    .ignoresSafeArea()
                    .background(.white)
                
                LocationSearchActivationButton()
                    .padding(.top, 72)
                    .onTapGesture {
                        newRecordState = .searchLocations
                    }
                
                MapViewActionButton(newRecordState: $newRecordState)
                    .padding(.leading)
                    .padding(.top, 4)
            }
        } else if (newRecordState == .searchLocations){
            LocationSearchView(newRecordState: $newRecordState)
            
        }
    }
}

#Preview {
    FullMapView(newRecordState: .constant(.fullMap))
        .environmentObject(LocationSearchViewModel())
}
