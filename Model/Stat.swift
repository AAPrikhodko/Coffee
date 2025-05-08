//
//  StatPoint.swift
//  Coffee
//
//  Created by Andrei on 06.05.2025.
//

import Foundation
import SwiftUICore

struct StatPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

enum TimeRange: Int, CaseIterable, Identifiable {
    case last10 = 10
    case last30 = 30
    case last90 = 90

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .last10: return "10 Days"
        case .last30: return "30 Days"
        case .last90: return "90 Days"
        }
    }
}

struct DrinkTypeStats: Identifiable {
    var type: DrinkType
    var count: Int
    
    var id: DrinkType { type }
}
enum ChartColor {
    static func forDrink(_ type: DrinkType) -> Color {
        switch type {
        case .cappuccino: return .brown
        case .latte: return .orange
        case .flatWhite: return .blue
        case .americano: return .green
        case .espresso: return .purple
        case .macchiato: return .pink
        }
    }
}

struct MonthlyExpense: Identifiable {
    var month: Date
    var total: Double
    
    var id: Date { month }
}
