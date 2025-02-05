//
//  Coffee.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import Foundation
import MapKit

struct Record: Identifiable, Hashable {
    var id: UUID
    
    var type: CoffeeType
    var size: CoffeeSize
    var price: Double
    var date: Date
    var place: Place
}

struct Place: Identifiable, Hashable {
    var id: UUID
    
    var location: CLLocation?
    var address: String
    var type: PlaceType
}

enum PlaceType: Int, Identifiable, CaseIterable, Hashable {
    case bar
    case cafe
    case hotel
    case home
    case office
    case friends
    
    var title: String {
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
        case .friends:
            return "Friends"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum CoffeeType: Int, Identifiable, CaseIterable, Hashable {
    case americano
    case latte
    case cappuccino
    case macchiato
    case flatWhite
    case mocha
    case icedCoffee
    case espresso
    
    var title: String {
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
        case .mocha:
            return "Mocha"
        case .icedCoffee:
            return "Iced Coffee"
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
        case .mocha:
            return "Mocha"
        case .icedCoffee:
            return "Iced Coffee"
        case .espresso:
            return "Espresso"
        }
    }
    
    var id: Int { return self.rawValue }
}

enum CoffeeSize: Int, Identifiable, CaseIterable, Hashable {
    case _50
    case _100
    case _150
    case _200
    case _250
    case _300
    case _350
    case _400
    case _450
    case _500
    
    var title: String {
        switch self {
        case ._50: return "50"
        case ._100: return "100"
        case ._150: return "150"
        case ._200: return "200"
        case ._250: return "250"
        case ._300: return "300"
        case ._350: return "350"
        case ._400: return "400"
        case ._450: return "450"
        case ._500: return "500"
        }
    }

    var id: Int { return self.rawValue }
}

enum NewRecordState {
    case collectingData
    case fullMap
    case searchLocations
}
