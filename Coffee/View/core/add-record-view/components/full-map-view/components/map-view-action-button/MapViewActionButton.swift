//
//  MapViewActionButton.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var newRecordState: NewRecordState
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                newRecordState = .collectingData
            }
        } label: {
            Image(systemName: "arrow.left")
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: .black, radius: 6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)

    }
}

#Preview {
    MapViewActionButton(newRecordState: .constant(.collectingData))
}
