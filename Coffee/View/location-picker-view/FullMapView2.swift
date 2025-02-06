//
//  FullMapView2.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import MapKit

struct FullMapView2: View {
    @Binding var navigationPath: [LocationPickerRoute]
    
    var body: some View {
        Map()
            .ignoresSafeArea(edges: .all)
    }
}

#Preview {
    FullMapView2(navigationPath: .constant([.fullMap]))
}
