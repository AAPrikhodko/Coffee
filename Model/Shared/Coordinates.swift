//
//  Coordinates.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import Foundation
import CoreLocation

struct Coordinates: Codable, Hashable {
    var latitude: Double
    var longitude: Double

    // MARK: - Инициализаторы
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    init(from location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }

    // MARK: - Преобразования

    var asCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var clLocation: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
