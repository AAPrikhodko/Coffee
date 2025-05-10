//
//  GeoMapView.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import SwiftUI
import MapKit

struct GeoMapView: View {
    let clusters: [Cluster]

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
    )

    @State private var selectedCluster: Cluster?

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: clusters) { cluster in
                MapAnnotation(coordinate: cluster.coordinate) {
                    Button {
                        selectedCluster = cluster
                    } label: {
                        VStack(spacing: 4) {
                            Text("\(cluster.records.count) ☕")
                                .font(.caption2)
                                .padding(6)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .shadow(radius: 2)
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                zoomToFitAllClusters()
            }

            if let cluster = selectedCluster {
                BottomSheet {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(cluster.records.count) record(s)")
                                .font(.headline)
                            Spacer()
                            Button("Close") {
                                selectedCluster = nil
                            }
                        }

                        Divider()

                        ScrollView {
                            ForEach(cluster.records) { record in
                                RecordRowView(record: record,
                                              onEdit: { /* handle editing */ },
                                              onDelete: { /* handle deletion */ })
                                    .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private func zoomToFitAllClusters() {
        guard !clusters.isEmpty else { return }

        let coordinates = clusters.map(\.coordinate)
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max(maxLat - minLat, 1.0) * 1.5,
            longitudeDelta: max(maxLon - minLon, 1.0) * 1.5
        )

        region = MKCoordinateRegion(center: center, span: span)
    }
}

struct BottomSheet<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            VStack {
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray.opacity(0.4))
                    .padding(.top, 8)

                content
            }
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .transition(.move(edge: .bottom))
        }
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeInOut, value: UUID()) // For smoother appearance
    }
}

