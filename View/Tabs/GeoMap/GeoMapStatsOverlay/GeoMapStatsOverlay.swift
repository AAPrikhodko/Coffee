//
//  GeoMapStatsOverlay.swift
//  Coffee
//
//  Created by Andrei on 11.05.2025.
//

import SwiftUI

struct GeoMapStatsOverlay: View {
    let records: [Record]
    var onShowDetails: () -> Void

    @State private var isExpanded = false
    @GestureState private var dragOffset = CGSize.zero

    private var totalCups: Int {
        records.count
    }

    private var uniqueCities: Int {
        records.map { $0.place.cityName }.uniqued.count
    }

    private var uniqueCountries: Int {
        records.map { $0.place.countryCode ?? "?" }.uniqued.count
    }

    private var favoriteCity: String? {
        let grouped = records.group { $0.place.cityName }
        return grouped.max(by: { $0.value.count < $1.value.count })?.key
    }

    var body: some View {
        VStack(spacing: 6) {
            if isExpanded {
                VStack(spacing: 8) {
                    HStack {
                        Text("☕ \(totalCups) cups")
                        Spacer()
                        Text("🏙️ \(uniqueCities) cities")
                        Spacer()
                        Text("🌍 \(uniqueCountries) countries")
                    }
                    .font(.caption)

                    if let city = favoriteCity {
                        Text("❤️ Favorite: \(city)")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }

                    Button {
                        onShowDetails()
                    } label: {
                        Text("See full stats")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.accentColor.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.top, 2)
                }
                .transition(.move(edge: .top))
            } else {
                HStack {
                    Text("📊 Geo Stats")
                        .font(.caption)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: "chevron.up")
                        .font(.caption)
                }
            }
        }
        .padding(.all, 10)
        .frame(maxWidth: 320)
        .background(.ultraThinMaterial)
        .cornerRadius(12)
        .shadow(radius: 3)
        .gesture(
            DragGesture(minimumDistance: 10)
                .updating($dragOffset) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.height < -10 {
                        isExpanded = true
                    } else if value.translation.height > 10 {
                        isExpanded = false
                    }
                }
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                isExpanded.toggle()
            }
        }
    }
}

