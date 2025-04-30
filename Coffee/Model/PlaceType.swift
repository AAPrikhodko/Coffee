//
//  PlaceType.swift
//  Coffee
//
//  Created by Andrei on 29.04.2025.
//

enum PlaceType: Int, Identifiable, CaseIterable, Hashable {
    case bar
    case cafe
    case hotel
    case home
    case office
    
    var displayName: String {
        switch self {
        case .bar:
            return "Bar"
        case .cafe:
            return "Cafe"
        case .hotel:
            return "Hotel"
        case .home:
            return "Home"
        case .office:
            return "Office"
        }
    }
    
    var id: Int { rawValue }
}
