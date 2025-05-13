//
//  GeoMapTabView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI

struct GeoMapTabView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel
    @State private var mapMode: MapMode = .locations
    @State private var selectedCountry: CountrySelection?
    @State private var showStatsDetail = false

    private var allRecords: [Record] {
        recordsViewModel.records
    }

    private var recordsBySelectedCountry: [Record] {
        guard let code = selectedCountry?.code else { return [] }
        return allRecords.filter { $0.place.countryCode == code }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                Group {
                    switch mapMode {
                    case .locations:
                        GeoMapView(records: allRecords)
                            .transition(.opacity)

                    case .countries:
                        ZStack(alignment: .top) {
                            GeoCountryMapView(
                                records: allRecords,
                                selectedCountryCode: Binding(
                                    get: { selectedCountry?.code },
                                    set: { newCode in
                                        selectedCountry = newCode.map { CountrySelection(code: $0) }
                                    }
                                )
                            )
                            GeoMapStatsOverlay(records: allRecords) {
                                showStatsDetail = true
                            }
                            .padding(.top, geometry.safeAreaInsets.top + 8) // 👈 Смещение под статусбар
                        }
                        .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: mapMode)
                .edgesIgnoringSafeArea(.top) // ⬅️ Только верх, низ — остаётся для табов

                // Кнопка смены режима — правый нижний угол
                Menu {
                    ForEach(MapMode.allCases) { mode in
                        Button {
                            withAnimation {
                                mapMode = mode
                                selectedCountry = nil
                            }
                        } label: {
                            Label(mode.label, systemImage: mode.iconName)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(.ultraThinMaterial.opacity(0.9))
                                .cornerRadius(8)
                        }
                    }
                } label: {
                    Image(systemName: "map")
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding([.bottom, .trailing], 20)
            }
            .sheet(item: $selectedCountry) { selection in
                CountryStatsSheet(
                    countryCode: selection.code,
                    records: recordsBySelectedCountry
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $showStatsDetail) {
                GeoStatsDetailView()
            }
        }
    }
}



// 🔹 Режимы с иконками
enum MapMode: String, CaseIterable, Identifiable {
    case locations
    case countries

    var id: String { rawValue }

    var label: String {
        switch self {
        case .locations: return "Locations"
        case .countries: return "Countries"
        }
    }

    var iconName: String {
        switch self {
        case .locations: return "mappin.and.ellipse"
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

