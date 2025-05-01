//
//  LocationSearchActivationButton.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI

struct LocationSearchActivationButton: View {
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.horizontal)
            
            Text("Search location...")
                .foregroundColor(Color(.darkGray))
           
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(
            Capsule()
                .fill(Color(.white))
                .shadow(color: .black, radius: 5)
        )
    }
}

#Preview {
    LocationSearchActivationButton()
}
