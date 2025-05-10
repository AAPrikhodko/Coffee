//
//  GeoMapTabView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI

struct GeoMapTabView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel
    @State private var selectedRange: GeoTimeRange = .last30Days

    private var filteredRecords: [Record] {
        recordsViewModel.records.filter { selectedRange.includes($0.date) }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 🔹 Picker
                Picker("Range", selection: $selectedRange) {
                    ForEach(GeoTimeRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                // 🔹 Full-height map (excluding safe area bottom)
                GeoMapView(records: filteredRecords)
                    .frame(height: geometry.size.height - 80) // 80 — примерная высота таб-бара и пикера
                    .clipShape(RoundedRectangle(cornerRadius: 0))
            }
        }
        .navigationTitle("Geo Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}


