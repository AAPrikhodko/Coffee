//
//  RecordRowView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUICore
import SwiftUI

struct RecordRowView: View {
    let record: Record
    var onEdit: () -> Void = {}
    var onDelete: () -> Void = {}

    var body: some View {
        HStack(spacing: 12) {
            Image(record.drinkType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.drinkType.displayName)
                    .font(.headline)

                Text(shortPlaceDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(formattedPrice)
                .font(.subheadline)
        }
        .padding(.vertical, 6)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive, action: onDelete) {
                Label("Delete", systemImage: "trash")
            }

            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
    }

    var formattedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = record.currency.rawValue
        return formatter.string(from: NSNumber(value: record.price))
            ?? "\(record.currency.symbol)\(String(format: "%.2f", record.price))"
    }

    var shortPlaceDescription: String {
        let components = record.place.address
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        return components.suffix(2).joined(separator: ", ")
    }
}


