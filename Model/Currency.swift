//
//  Currencies.swift
//  Coffee
//
//  Created by Andrei on 06.05.2025.
//

import Foundation

enum Currency: String, CaseIterable, Identifiable, Codable, Hashable {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"
    case rub = "RUB"
    case jpy = "JPY"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .usd: return "USD"
        case .eur: return "EUR"
        case .gbp: return "GBP"
        case .rub: return "RUB"
        case .jpy: return "JPY"
        }
    }

    var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        case .rub: return "₽"
        case .jpy: return "¥"
        }
    }
}
