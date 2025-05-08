//
//  StatTag.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUI

struct StatTag: View {
    let label: String
    var icon: String? = nil
    var color: Color = .primary
    var background: Color = Color.gray.opacity(0.15)

    var body: some View {
        HStack(spacing: 4) {
            if let icon {
                Image(systemName: icon)
                    .font(.caption2)
            }

            Text(label)
                .font(.caption2)
                .fontWeight(.medium)
                .transition(.opacity)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(background)
        .foregroundColor(color)
        .clipShape(Capsule())
        .animation(.easeInOut(duration: 0.2), value: label)
    }
}
