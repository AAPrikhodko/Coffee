//
//  GeoMap.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import Foundation

enum GeoTimeRange: String, CaseIterable, Identifiable {
    case last30
    case lastYear
    case allTime

    var id: String { rawValue }

    var label: String {
        switch self {
        case .last30:
            return "30 days"
        case .lastYear:
            return "1 year"
        case .allTime:
            return "All time"
        }
    }

    func includes(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        switch self {
        case .last30:
            if let pastDate = calendar.date(byAdding: .day, value: -30, to: now) {
                return date >= pastDate
            }
        case .lastYear:
            if let pastDate = calendar.date(byAdding: .year, value: -1, to: now) {
                return date >= pastDate
            }
        case .allTime:
            return true
        }

        return false
    }
}

extension Coordinates {
    func roundedToGrid(precision: Double = 0.0005) -> Coordinates {
        let roundedLat = (latitude / precision).rounded() * precision
        let roundedLon = (longitude / precision).rounded() * precision
        return Coordinates(latitude: roundedLat, longitude: roundedLon)
    }
}
