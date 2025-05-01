//
//  AddDrinkButton.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import SwiftUI

struct AddDrinkButton: View {
    @Binding var showAddDrinkSheet: Bool
    
    var body: some View {
        Button {
            showAddDrinkSheet.toggle()
        } label: {
            Text("Add drink")
                .foregroundStyle(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 360, height: 48)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview {
    AddDrinkButton(showAddDrinkSheet: .constant(false))
}
