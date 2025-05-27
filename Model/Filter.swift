//
//  Filter.swift
//  Coffee
//
//  Created by Andrei on 22.05.2025.
//

import SwiftUI

enum FilterType: String {
    case coffeeType, country, city
}

struct Filter: Identifiable, Equatable {
    var id: String { rawValue }
    let type: FilterType
    let value: String

    var rawValue: String {
        switch type {
        case .coffeeType: return value
        case .country: return value
        case .city: return value
        }
    }

    var displayValue: String {
        value
    }
}
