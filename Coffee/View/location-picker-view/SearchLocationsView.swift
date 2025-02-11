//
//  SearchLocationsView.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI

struct SearchLocationsView: View {
    @Binding var navigationPath: [NewRecordRoute]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SearchLocationsView(navigationPath: .constant([.searchLocation]))
}
