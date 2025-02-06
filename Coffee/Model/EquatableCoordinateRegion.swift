//
//  EquatableCoordinateRegion.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import MapKit

struct EquatableCoordinateRegion: Equatable {
    var center: CLLocationCoordinate2D
    var span: MKCoordinateSpan

    init(region: MKCoordinateRegion) {
        self.center = region.center
        self.span = region.span
    }

    var mkRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: center, span: span)
    }

    static func == (lhs: EquatableCoordinateRegion, rhs: EquatableCoordinateRegion) -> Bool {
        lhs.center.latitude == rhs.center.latitude &&
        lhs.center.longitude == rhs.center.longitude &&
        lhs.span.latitudeDelta == rhs.span.latitudeDelta &&
        lhs.span.longitudeDelta == rhs.span.longitudeDelta
    }
}
