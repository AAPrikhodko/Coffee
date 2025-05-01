//
//  Coffee.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import Foundation

struct Record: Identifiable, Hashable, Codable {
    var id: UUID
    var userId: UUID
    var drinkType: DrinkType
    var drinkSize: DrinkSize
    var price: Double
    var date: Date
    var place: Place
    
    static var example = Record(
        id: UUID(),
        userId: UUID(),
        drinkType: .espresso,
        drinkSize: .ml100,
        price: 5.0,
        date: Date(timeIntervalSinceNow: -7776000),
        place: Place.examples[0]
    )
    
    static var examples = [
        Record(id: UUID(), userId: UUID(), drinkType: .americano, drinkSize: .ml50, price: 10.99, date: Date(timeIntervalSinceNow: -7_200_000), place: Place.examples[0]),
        Record(id: UUID(), userId: UUID(), drinkType: .cappuccino, drinkSize: .ml200, price: 7.99, date: Date(timeIntervalSinceNow: -14_400_000), place: Place.examples[1]),
        Record(id: UUID(), userId: UUID(), drinkType: .flatWhite, drinkSize: .ml300, price: 2.33, date: Date(timeIntervalSinceNow: -21_600_000), place: Place.examples[2]),
        Record(id: UUID(), userId: UUID(), drinkType: .macchiato, drinkSize: .ml400, price: 10.40, date: Date(timeIntervalSinceNow: -28_800_000), place: Place.examples[3]),
        Record(id: UUID(), userId: UUID(), drinkType: .americano, drinkSize: .ml150, price: 5.15, date: Date(timeIntervalSinceNow: -36_000_000), place: Place.examples[4]),
        Record(id: UUID(), userId: UUID(), drinkType: .cappuccino, drinkSize: .ml100, price: 3.12, date: Date(timeIntervalSinceNow: -43_200_000), place: Place.examples[5]),
        Record(id: UUID(), userId: UUID(), drinkType: .americano, drinkSize: .ml200, price: 4.23, date: Date(timeIntervalSinceNow: -50_400_000), place: Place.examples[6]),
        Record(id: UUID(), userId: UUID(), drinkType: .espresso, drinkSize: .ml450, price: 12.99, date: Date(timeIntervalSinceNow: -57_600_000), place: Place.examples[7]),
        Record(id: UUID(), userId: UUID(), drinkType: .cappuccino, drinkSize: .ml250, price: 3.55, date: Date(timeIntervalSinceNow: -64_800_000), place: Place.examples[8]),
        Record(id: UUID(), userId: UUID(), drinkType: .latte, drinkSize: .ml150, price: 6.00, date: Date(timeIntervalSinceNow: -72_000_000), place: Place.examples[9])
    ]
    
    static func threeMonthsExamples() -> [Record]  {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!

        let exampleRecords: [Record] = (1...300).map { _ in
            return Record(
                id: UUID(),
                userId: UUID(),
                drinkType: DrinkType.allCases.randomElement()!,
                drinkSize: DrinkSize.allCases.randomElement()!,
                price: Double.random(in: 1.00...20.00),
                date: Date.random(in: threeMonthsAgo...Date()),
                place: Place.examples.randomElement()!
            )
        }
        
        return exampleRecords.sorted { $0.date < $1.date }
    }
    
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
