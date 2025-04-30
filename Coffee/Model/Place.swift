//
//  Place.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import Foundation
import MapKit

struct Place: Identifiable, Hashable {
    var id: UUID
    
    var location: CLLocation?
    var address: String
    var type: PlaceType
    
    static var examples: [Place] = [
        Place(id: UUID(), location: CLLocation(latitude: 40.712776, longitude: -74.005974), address: "New York, NY, USA", type: .cafe),
        Place(id: UUID(), location: CLLocation(latitude: 48.856613, longitude: 2.352222), address: "Paris, France", type: .cafe),
        Place(id: UUID(), location: CLLocation(latitude: 51.507351, longitude: -0.127758), address: "London, UK", type: .hotel),
        Place(id: UUID(), location: CLLocation(latitude: 35.689487, longitude: 139.691711), address: "Tokyo, Japan", type: .bar),
        Place(id: UUID(), location: CLLocation(latitude: 34.052235, longitude: -118.243683), address: "Los Angeles, CA, USA", type: .office),
        Place(id: UUID(), location: CLLocation(latitude: 41.902782, longitude: 12.496366), address: "Rome, Italy", type: .cafe),
        Place(id: UUID(), location: CLLocation(latitude: 55.755825, longitude: 37.617298), address: "Moscow, Russia", type: .home),
        Place(id: UUID(), location: CLLocation(latitude: 52.520008, longitude: 13.404954), address: "Berlin, Germany", type: .cafe),
        Place(id: UUID(), location: CLLocation(latitude: 37.774929, longitude: -122.419418), address: "San Francisco, CA, USA", type: .hotel),
        Place(id: UUID(), location: CLLocation(latitude: 45.464211, longitude: 9.191383), address: "Milan, Italy", type: .bar)
    ]
}
