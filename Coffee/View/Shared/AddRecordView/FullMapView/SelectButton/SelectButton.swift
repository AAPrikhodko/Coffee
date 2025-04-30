//
//  SelectButton.swift
//  Coffee
//
//  Created by Andrei on 04.02.2025.
//

import SwiftUI

struct SelectButton: View {
    
    var body: some View {
        Text("Select")
            .foregroundColor(Color(.black))
            .frame(width: (UIScreen.main.bounds.width - 64)/2, height: 50)
            .background(
                Capsule()
                    .fill(Color(.white))
                    .shadow(color: .black, radius: 5)
            )
    }
}

#Preview {
    SelectButton()
}
