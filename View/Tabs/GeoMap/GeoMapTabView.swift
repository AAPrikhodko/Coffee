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

    var filteredRecords: [Record] {
        recordsViewModel.records.filter {
            selectedRange.includes($0.date)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Picker("Range", selection: $selectedRange) {
                    ForEach(GeoTimeRange.allCases) { range in
                        Text(range.label).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Ограничиваем карту, чтобы не перекрывать TabView
                GeoMapView(records: filteredRecords)
                    .edgesIgnoringSafeArea(.horizontal)
            }
            .navigationTitle("Geo Map")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

