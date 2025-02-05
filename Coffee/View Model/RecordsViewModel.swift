//
//  CoffeeViewModel.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation
import CoreLocation
import MapKit

@Observable
class RecordsViewModel {
    var records: [Record] = [
        Record(
            id: UUID(),
            type: .americano,
            size: ._300,
            price: 10,
            date: Date(),
            place: Place(
                id: UUID(),
                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
                address: "",
                type: .cafe
            )
        ),
        Record(
            id: UUID(),
            type: .cappuccino,
            size: ._200,
            price: 12.99,
            date: Date(),
            place: Place(
                id: UUID(),
                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
                address: "",
                type: .cafe
            )
        ),
        Record(
            id: UUID(),
            type: .espresso,
            size: ._100,
            price: 7.55,
            date: Date(),
            place: Place(
                id: UUID(),
                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
                address: "",
                type: .hotel
            )
        ),
        Record(
            id: UUID(),
            type: .latte,
            size: ._400,
            price: 15.00,
            date: Date(),
            place: Place(
                id: UUID(),
                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
                address: "",
                type: .hotel
            )
        ),
    ]
    
    
    init() {
        // get records
    }
    
    func addRecord(_ record: Record) {
        records.append(record)
    }
}
