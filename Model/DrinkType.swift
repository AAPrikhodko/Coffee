//
//  DrinkType.swift
//  Coffee
//
//  Created by Andrei on 29.04.2025.
//

import SwiftUICore

enum DrinkType: String, Codable, Identifiable, CaseIterable, Hashable {
    case americano
    case latte
    case cappuccino
    case macchiato
    case flatWhite
    case espresso
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .americano:
            return "Americano"
        case .latte:
            return "Latte"
        case .cappuccino:
            return "Cappuccino"
        case .macchiato:
            return "Macchiato"
        case .flatWhite:
            return "Flat White"
        case .espresso:
            return "Espresso"
        }
    }
    
    var color: Color {
        switch self {
        case .americano: return Color(hex: "#c9b398")
        case .latte: return Color(hex: "#0b6eed")
        case .cappuccino: return Color(hex: "#3239ae")
        case .macchiato: return Color(hex: "#9f341e")
        case .flatWhite: return Color(hex: "#a4eda3")
        case .espresso: return Color(hex: "#8d471c")
        }
    }
        
    var imageName: String {
        switch self {
        case .americano:
            return "Americano"
        case .latte:
            return "Latte"
        case .cappuccino:
            return "Cappuccino"
        case .macchiato:
            return "Macchiato"
        case .flatWhite:
            return "Flat White"
        case .espresso:
            return "Espresso"
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }
}
