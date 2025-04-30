//
//  CoffeeSizeSegment.swift
//  Coffee
//
//  Created by Andrei on 27.01.2025.
//

import SwiftUI

struct CoffeeSizeSegment: View {
    @State private var selectedSize: String = "100"
    var sizes: [String] = ["100", "200", "300"]
    
    var body: some View {
        HStack {
            Picker("", selection: $selectedSize) {
                ForEach(sizes, id: \.self) {
                    Text($0)
                        .tag(Int($0)!)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Text("ml")
                .font(.title)
                .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CoffeeSizeSegment()
}
