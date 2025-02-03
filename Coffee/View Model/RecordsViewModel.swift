//
//  CoffeeViewModel.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation

@Observable
class RecordsViewModel {
    var records: [Record] = [
        Record(
            id: UUID(),
            type: .americano,
            size: ._300,
            price: 10,
            place: Place(
                id: UUID(),
                name: "Starbucks",
                type: .cafe
            )
        ),
        Record(
            id: UUID(),
            type: .cappuccino,
            size: ._200,
            price: 12.99,
            place: Place(
                id: UUID(),
                name: "Starhit",
                type: .cafe
            )
        ),
        Record(
            id: UUID(),
            type: .espresso,
            size: ._100,
            price: 7.55,
            place: Place(
                id: UUID(),
                name: "Raddisson",
                type: .hotel
            )
        ),
        Record(
            id: UUID(),
            type: .latte,
            size: ._400,
            price: 15.00,
            place: Place(
                id: UUID(),
                name: "Hotel InterContinental",
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
