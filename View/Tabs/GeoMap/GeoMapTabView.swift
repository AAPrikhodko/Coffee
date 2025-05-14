//
//  GeoMapTabView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI

struct GeoMapTabView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel
    @Environment(AuthViewModel.self) private var authViewModel
    
    @State private var mapMode: MapMode = .locations
    @State private var selectedCountry: CountrySelection?
    @State private var selectedRecordForEdit: Record?
    @State private var showStatsDetail = false

    private var allRecords: [Record] {
        recordsViewModel.records
    }

    private var recordsBySelectedCountry: [Record] {
        guard let selectedISO = selectedCountry?.code else { return [] }

        return allRecords.filter {
            guard let countryName = $0.place.countryCode,
                  let isoCode = isoA2(from: countryName) else { return false }
            return isoCode.uppercased() == selectedISO
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                Group {
                    switch mapMode {
                    case .locations:
                        LocationsMapView(records: allRecords)
                            .transition(.opacity)

                    case .countries:
                        ZStack(alignment: .top) {
                            CountriesMapView(
                                records: allRecords,
                                selectedCountryCode: Binding(
                                    get: { selectedCountry?.code },
                                    set: { newCode in
                                        selectedCountry = newCode.map { CountrySelection(code: $0) }
                                    }
                                )
                            )
                            StatsOverlayView(records: allRecords) {
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
                            Label {
                                Text((mode == mapMode ? " ✓   " : "       ") + mode.label)
                            } icon: {
                                Image(systemName: mode.iconName)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "map")
                        .font(.title3)
                        .padding(10)
                        .background(.ultraThinMaterial.opacity(0.9))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .padding([.bottom, .trailing], 20)

            }
            .sheet(item: $selectedCountry) { selection in
                ClusterDetailSheet(
                    records: recordsBySelectedCountry,
                    onEdit: { record in
                        selectedCountry = nil
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            selectedRecordForEdit = record
                        }
                    }
                )
                .presentationDetents([.medium, .large])
            }
            .sheet(item: $selectedRecordForEdit) { record in
                AddRecordView(
                    isSheetShown: .constant(false),
                    authViewModel: authViewModel,
                    recordsViewModel: recordsViewModel,
                    editingRecord: record
                )
            }
            .sheet(isPresented: $showStatsDetail) {
                GeoStatsView()
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
