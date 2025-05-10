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

    private var annotationRecords: [Record] {
        records.compactMap {
            guard let coords = $0.place.coordinates,
                  coords.latitude != 0,
                  coords.longitude != 0
            else { return nil }
            return $0
        }
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: annotationRecords) { record in
            MapAnnotation(coordinate: record.place.coordinates!.asCLLocationCoordinate2D) {
                VStack(spacing: 4) {
                    Image(systemName: "cup.and.saucer.fill")
                        .foregroundColor(.brown)
                    Text(record.drinkType.displayName)
                        .font(.caption2)
                        .padding(4)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(4)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            zoomToFitAllAnnotations()
        }
    }

    private func zoomToFitAllAnnotations() {
        guard !annotationRecords.isEmpty else { return }

        let coordinates = annotationRecords.compactMap { $0.place.coordinates?.asCLLocationCoordinate2D }
        let latitudes = coordinates.map { $0.latitude }
        let longitudes = coordinates.map { $0.longitude }

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

