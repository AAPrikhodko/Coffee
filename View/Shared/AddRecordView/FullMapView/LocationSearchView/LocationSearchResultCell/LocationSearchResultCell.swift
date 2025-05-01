//
//  LocationSearchResultCell.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundStyle(.cyan)
                .accentColor(.white)
                .frame(width: 40, height: 40)
                
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundStyle(.primary)
                
                Text(subtitle)
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
        }
        .padding(.leading)
    
    }
}

#Preview {
    LocationSearchResultCell(title: "Sturbucks Coffee", subtitle: "123 Main St, Anytown, USA")
}
