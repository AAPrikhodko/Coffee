//
//  GeoMap.swift
//  Coffee
//
//  Created by Andrei on 10.05.2025.
//

import Foundation

enum GeoTimeRange: String, CaseIterable, Identifiable {
    case last30Days = "1M"
    case lastYear = "1Y"
    case allTime = "All"

    var id: String { rawValue }

    func includes(_ date: Date) -> Bool {
        let now = Date()
        let calendar = Calendar.current

        switch self {
        case .last30Days:
            guard let start = calendar.date(byAdding: .day, value: -30, to: now) else { return false }
            return (start...now).contains(date)
        case .lastYear:
            guard let start = calendar.date(byAdding: .year, value: -1, to: now) else { return false }
            return (start...now).contains(date)
        case .allTime:
            return true
        }
    }
}

