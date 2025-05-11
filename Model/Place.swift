//
//  Place.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import Foundation
import MapKit
import CoreLocation


struct Place: Identifiable, Hashable, Codable {
    var id: UUID
    
    var coordinates: Coordinates?
    var address: String
    var type: PlaceType
    
    var cityName: String {
        let components = address.split(separator: ",")
        return components.dropLast().last.map(String.init) ?? "Unknown"
    }

    var countryCode: String? {
        // Предположим, что страна — последнее слово в адресе
        address.split(separator: ",").last.map { $0.trimmingCharacters(in: .whitespaces) }
    }
}
