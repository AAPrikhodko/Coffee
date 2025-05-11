//
//  GeoStatsDetailView.swift
//  Coffee
//
//  Created by Andrei on 11.05.2025.
//

import SwiftUI

struct GeoStatsDetailView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Geo Statistics")
                    .font(.title2)
                    .fontWeight(.bold)

                StatRow(label: "Total cups", value: "\(recordsViewModel.totalCups)")
                StatRow(label: "Cities visited", value: "\(recordsViewModel.uniqueCities)")
                StatRow(label: "Countries visited", value: "\(recordsViewModel.uniqueCountries)")

                if let city = recordsViewModel.favoriteCity {
                    StatRow(label: "Favorite city", value: city)
                }

                if let country = recordsViewModel.favoriteCountry {
                    StatRow(label: "Favorite country", value: country)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Geo Stats")
        .navigationBarTitleDisplayMode(.inline)
    }
}


private struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}
