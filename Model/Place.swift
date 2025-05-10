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
}

struct Cluster: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let records: [Record]
}
