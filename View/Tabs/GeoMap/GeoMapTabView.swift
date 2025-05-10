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

    private var filteredRecords: [Record] {
        recordsViewModel.records.filter { selectedRange.includes($0.date) }
    }

    private var clusters: [Cluster] {
        Dictionary(grouping: filteredRecords) { record in
            record.place.coordinates?.roundedToGrid(precision: 0.0005)
        }
        .compactMap { key, records in
            guard let key else { return nil }
            return Cluster(coordinate: key.asCLLocationCoordinate2D, records: records)
        }
    }

    var body: some View {
        VStack(spacing: 12) {
            Picker("Range", selection: $selectedRange) {
                ForEach(GeoTimeRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            GeoMapView(clusters: clusters)
        }
        .navigationTitle("Geo Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}



