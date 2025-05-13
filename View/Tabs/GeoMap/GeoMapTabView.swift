//
//  GeoMapTabView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI

struct GeoMapTabView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel

    @State private var selectedRange: GeoTimeRange = .last30
    @State private var mapMode: MapMode = .clusters
    @State private var selectedCountry: CountrySelection?

    private var filteredRecords: [Record] {
        recordsViewModel.records.filter {
            selectedRange.includes($0.date)
        }
    }

    private var recordsBySelectedCountry: [Record] {
        guard let code = selectedCountry?.code else { return [] }
        return filteredRecords.filter { $0.place.countryCode == code }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // 🔹 Диапазон времени
                Picker("Range", selection: $selectedRange) {
                    ForEach(GeoTimeRange.allCases) { range in
                        Text(range.label).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // 🔹 Режим карты
                HStack(spacing: 20) {
                    ForEach(MapMode.allCases) { mode in
                        Button {
                            mapMode = mode
                            selectedCountry = nil
                        } label: {
                            VStack(spacing: 4) {
                                Image(systemName: mode.iconName)
                                    .font(.system(size: 18, weight: .semibold))
                                Text(mode.label)
                                    .font(.caption2)
                            }
                            .foregroundColor(mapMode == mode ? .white : .primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(mapMode == mode ? Color.accentColor : Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.horizontal)

                // 🔹 Карта + Легенда
                ZStack(alignment: .top) {
                    switch mapMode {
                    case .clusters:
                        GeoMapView(records: filteredRecords)
                            .edgesIgnoringSafeArea(.horizontal)

                    case .countries:
                        GeoCountryMapView(
                            records: filteredRecords,
                            selectedCountryCode: Binding(
                                get: { selectedCountry?.code },
                                set: { newCode in
                                    selectedCountry = newCode.map { CountrySelection(code: $0) }
                                }
                            )
                        )
                        .edgesIgnoringSafeArea(.horizontal)

                        VStack(spacing: 8) {
                            Text("Tap on a country to view your stats")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .padding(6)
                                .background(.ultraThinMaterial)
                                .cornerRadius(8)

                            Spacer()

                            HStack(spacing: 12) {
                                Label("Visited", systemImage: "square.fill")
                                    .foregroundColor(.yellow)
                                Label("Not Visited", systemImage: "square.fill")
                                    .foregroundColor(.gray)
                            }
                            .font(.caption)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.bottom, 8)
                        }
                        .padding()
                    }
                }
            }
            .sheet(item: $selectedCountry) { selection in
                CountryStatsSheet(
                    countryCode: selection.code,
                    records: recordsBySelectedCountry
                )
                .presentationDetents([.medium, .large])
            }
            .navigationTitle("Geo Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


// 🔹 Режимы с иконками
enum MapMode: String, CaseIterable, Identifiable {
    case clusters
    case countries

    var id: String { rawValue }

    var label: String {
        switch self {
        case .clusters: return "Clusters"
        case .countries: return "Countries"
        }
    }

    var iconName: String {
        switch self {
        case .clusters: return "mappin.circle"
        case .countries: return "globe"
        }
    }
}

// 🔹 Обёртка для countryCode
struct CountrySelection: Identifiable, Equatable {
    let code: String
    var id: String { code }
}


struct CountryStatsSheet: View {
    let countryCode: String
    let records: [Record]

    var body: some View {
        NavigationStack {
            List {
                StatRow(label: "Country Code", value: countryCode)
                StatRow(label: "Total Drinks", value: "\(records.count)")
                StatRow(label: "Unique Cities", value: "\(Set(records.map { $0.place.cityName }).count)")

                if let top = records.group(by: \.drinkType).max(by: { $0.value.count < $1.value.count })?.key {
                    StatRow(label: "Top Drink", value: top.displayName)
                }

                let totalSpent = records.reduce(0) { $0 + $1.price }
                StatRow(label: "Total Spent", value: String(format: "%.2f", totalSpent))
            }
            .navigationTitle("Country Stats")
        }
    }

    private struct StatRow: View {
        let label: String
        let value: String

        var body: some View {
            HStack {
                Text(label)
                    .foregroundColor(.secondary)
                Spacer()
                Text(value)
            }
        }
    }
}

