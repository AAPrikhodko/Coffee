//
//  AddRecordTitleView.swift
//  Coffee
//
//  Created by Andrei on 30.01.2025.
//

import SwiftUI

struct AddRecordTitleView: View {
    @Binding var isSheetShown: Bool
    
    var body: some View {
        ZStack {
            Text("Add new drink")
                .font(.title)

            
            HStack {
                Spacer()
                
                Button {
                    isSheetShown.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.black)
                }
            }
        }
    }
}

#Preview {
    AddRecordTitleView(isSheetShown: .constant(false))
}
