//
//  GeoMap.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import Foundation

enum GeoTimeRange: String, CaseIterable, Identifiable {
    case last30 = "30d"
    case last365 = "1y"
    case allTime = "All"

    var id: String { rawValue }

    func includes(_ date: Date) -> Bool {
        let now = Date()
        switch self {
        case .last30:
            return date >= Calendar.current.date(byAdding: .day, value: -30, to: now)!
        case .last365:
            return date >= Calendar.current.date(byAdding: .day, value: -365, to: now)!
        case .allTime:
            return true
        }
    }
}

extension Coordinates {
    func roundedToGrid(precision: Double = 0.0005) -> Coordinates {
        let roundedLat = (latitude / precision).rounded() * precision
        let roundedLon = (longitude / precision).rounded() * precision
        return Coordinates(latitude: roundedLat, longitude: roundedLon)
    }
}
