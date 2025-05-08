//
//  RecordRowView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUICore

struct RecordRowView: View {
    let record: Record

    var body: some View {
        HStack(spacing: 12) {
            // Иконка напитка
            Image(record.drinkType.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 1)

            VStack(alignment: .leading, spacing: 4) {
                Text(record.drinkType.displayName)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(shortPlaceDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            Text(formattedPrice)
                .font(.subheadline)
        }
        .padding(.vertical, 6)
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

