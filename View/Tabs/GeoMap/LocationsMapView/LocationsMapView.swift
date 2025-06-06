//
//  LocationsMapView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//
import MapKit
import SwiftUI

struct LocationsMapView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(RecordsViewModel.self) private var recordsViewModel

    @State private var selectedRecordForEdit: Record?
    @State private var selectedCluster: RecordClusterWrapper?
    @State private var showFullGeoStats = false

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    )
    @State private var recordClusters: [RecordClusterWrapper] = []
    @State private var lastDelta: Double = 0

    let records: [Record]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Map(coordinateRegion: $region, annotationItems: recordClusters) { cluster in
                    MapAnnotation(coordinate: cluster.coordinate) {
                        Button {
                            selectedCluster = cluster
                        } label: {
                            Text("☕ \(cluster.records.count)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(6)
                                .background(Color.white.opacity(0.9))
                                .clipShape(Capsule())
                        }
                        .id(cluster.id)
                    }
                }

                StatsOverlayView(records: records) {
                    showFullGeoStats = true
                }
                .padding(.top, geometry.safeAreaInsets.top + 70) // 👈 теперь overlay не перекрывает статусбар
            }
            .edgesIgnoringSafeArea(.top) // ✅ только верх
        }

        // 📦 Sheet: кластер деталей
        .sheet(item: $selectedCluster) { cluster in
            ClusterDetailSheet(
                records: cluster.records,
                onEdit: { record in
                    selectedCluster = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        selectedRecordForEdit = record
                    }
                }
            )
            .presentationDetents([.medium, .large])
        }

        // ✏️ Sheet: редактирование записи
        .sheet(item: $selectedRecordForEdit) { record in
            AddRecordView(
                isSheetShown: .constant(false),
                authViewModel: authViewModel,
                recordsViewModel: recordsViewModel,
                editingRecord: record
            )
        }

        // 📊 Sheet: общая статистика
        .sheet(isPresented: $showFullGeoStats) {
            GeoStatsView()
        }

        .onAppear {
            zoomToFit()
            recordClusters = computeClusters()
            lastDelta = region.span.latitudeDelta
        }

        .onChange(of: region.span.latitudeDelta) { newDelta in
            if abs(newDelta - lastDelta) > 0.01 {
                lastDelta = newDelta
                recordClusters = computeClusters()
            }
        }
    }

    private func computeClusters() -> [RecordClusterWrapper] {
        let grouped = Dictionary(grouping: records.filter { $0.place.coordinates != nil }) { record in
            record.place.coordinates!.rounded(for: region.span)
        }
        return grouped.map { RecordClusterWrapper(records: $0.value) }
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

    var coordinate: CLLocationCoordinate2D {
        let coords = records.compactMap { $0.place.coordinates?.asCLLocationCoordinate2D }
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
        let clampedDelta = max(min(span.latitudeDelta, 10), 0.001)
        let precision: Double

        switch clampedDelta {
        case ..<0.1: precision = 0.001
        case ..<1: precision = 0.01
        case ..<10: precision = 0.1
        default: precision = 1.0
        }

        return Coordinates(
            latitude: (latitude / precision).rounded() * precision,
            longitude: (longitude / precision).rounded() * precision
        )
    }
}

struct ClusterDetailSheet: View {
    let records: [Record]
    var onEdit: (Record) -> Void

    var body: some View {
        if records.isEmpty {
            VStack(spacing: 16) {
                Spacer()
                Image(systemName: "cup.and.saucer.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.secondary)

                Text("You haven't drunk coffee in this country yet.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Spacer()
            }
        } else {
            Spacer(minLength: 12)
            
            List(records) { record in
                RecordRowView(
                    record: record,
                    onEdit: { onEdit(record) },
                    onDelete: {
                        // Optional: handle deletion
                    }
                )
            }
            .listStyle(.plain)
        }
    }
}


