//
//  DrinkType.swift
//  Coffee
//
//  Created by Andrei on 29.04.2025.
//

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
