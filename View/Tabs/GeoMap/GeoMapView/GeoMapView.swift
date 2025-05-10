//
//  GeoMapView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI
import MapKit

struct GeoMapView: View {
    let records: [Record]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    )

    @State private var selectedCluster: RecordClusterWrapper?

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: recordClusters) { cluster in
            MapAnnotation(coordinate: cluster.coordinate!) {
                Button {
                    selectedCluster = cluster
                } label: {
                    VStack(spacing: 4) {
                        Text("☕ \(cluster.records.count)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(6)
                            .background(Color.white.opacity(0.9))
                            .clipShape(Capsule())
                    }
                }
            }
        }
        .sheet(item: $selectedCluster) { cluster in
            ClusterDetailSheet(records: cluster.records)
        }
        .onAppear {
            zoomToFit()
        }
    }

    private var recordClusters: [RecordClusterWrapper] {
        let grouped = Dictionary(grouping: records.filter { $0.place.coordinates != nil }) { record in
            record.place.coordinates!.rounded(for: region.span)
        }

        return grouped
            .map { RecordClusterWrapper(records: $0.value) }
            .filter { $0.coordinate != nil } // ← Удаляем пустые координаты
    }

    private func zoomToFit() {
        guard !records.isEmpty else { return }

        let coords = records.compactMap { $0.place.coordinates?.asCLLocationCoordinate2D }
        let latitudes = coords.map(\.latitude)
        let longitudes = coords.map(\.longitude)

        let center = CLLocationCoordinate2D(
            latitude: (latitudes.min()! + latitudes.max()!) / 2,
            longitude: (longitudes.min()! + longitudes.max()!) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max(latitudes.max()! - latitudes.min()!, 0.05) * 1.5,
            longitudeDelta: max(longitudes.max()! - longitudes.min()!, 0.05) * 1.5
        )

        region = MKCoordinateRegion(center: center, span: span)
    }
}

struct RecordClusterWrapper: Identifiable, Equatable {
    let id = UUID()
    let records: [Record]

    var coordinate: CLLocationCoordinate2D? {
        let coords = records.compactMap { $0.place.coordinates?.asCLLocationCoordinate2D }
        guard !coords.isEmpty else { return nil }

        let avgLat = coords.map(\.latitude).reduce(0, +) / Double(coords.count)
        let avgLon = coords.map(\.longitude).reduce(0, +) / Double(coords.count)

        return CLLocationCoordinate2D(latitude: avgLat, longitude: avgLon)
    }

    static func == (lhs: RecordClusterWrapper, rhs: RecordClusterWrapper) -> Bool {
        lhs.records.map(\.id) == rhs.records.map(\.id)
    }
}

extension Coordinates {
    func rounded(for span: MKCoordinateSpan) -> Coordinates {
        let precision: Double

        if span.latitudeDelta < 0.1 {
            precision = 0.001
        } else if span.latitudeDelta < 1 {
            precision = 0.01
        } else if span.latitudeDelta < 10 {
            precision = 0.1
        } else {
            precision = 1.0
        }

        return Coordinates(
            latitude: (latitude / precision).rounded() * precision,
            longitude: (longitude / precision).rounded() * precision
        )
    }
}


struct ClusterDetailSheet: View {
    let records: [Record]

    var body: some View {
        NavigationStack {
            List(records) { record in
                RecordRowView(record: record)
            }
            .navigationTitle("Records (\(records.count))")
        }
    }
}

