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
    
    var body: some View {
        Map()
            .frame(height: 200)
            .listRowInsets(EdgeInsets())
            .onTapGesture {
                withAnimation(.spring()) {
                    navigationPath.append(.fullMap)
                }
            }
    }
}

#Preview {
    PreviewMapView(navigationPath: .constant([.previewMap]))
}
