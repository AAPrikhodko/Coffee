//
//  AddDrinkButton.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import SwiftUI

struct AddDrinkButton: View {
    @Binding var showSheet: Bool
    var title: String = "Add drink"
    var width: CGFloat = 360
    var height: CGFloat = 48

    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            Text(title)
                .foregroundStyle(.white)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: width, height: height)
                .background(.pink)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

//#Preview {
//    AddDrinkButton(showAddDrinkSheet: .constant(false))
//}
