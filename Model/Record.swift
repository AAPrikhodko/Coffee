//
//  Coffee.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import Foundation

struct Record: Identifiable, Hashable, Codable {
    var id: UUID
    var userId: String
    var drinkType: DrinkType
    var drinkSize: DrinkSize
    var price: Double
    var currency: Currency
    var date: Date
    var place: Place
}

enum NewRecordRoute {
    case mapPicker
    case searchLocation
}

extension Date {
    static func random(in range: ClosedRange<Date>) -> Date {
        let diff = range.upperBound.timeIntervalSinceReferenceDate - range.lowerBound.timeIntervalSinceReferenceDate
        let randomValue = diff * Double.random(in: 0...1) + range.lowerBound.timeIntervalSinceReferenceDate
        return Date(timeIntervalSinceReferenceDate: randomValue)
    }
}
