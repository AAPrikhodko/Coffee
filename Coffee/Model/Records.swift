//
//  Coffee.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import Foundation

struct Record: Identifiable, Hashable {
    var id: UUID
    
    var type: CoffeeType
    var size: CoffeeSize
    var price: Double
    var date: Date
    var place: Place
    
    static var example = Record(
        id: UUID(),
        type: .espresso,
        size: ._100,
        price: 5.0,
        date: Date(timeIntervalSinceNow: -7776000),
        place: Place.examples[0]
    )
    
    static var examples = [
        Record(id: UUID(), type: .americano, size: ._150, price: 10.99, date: Date(timeIntervalSinceNow: -7_200_000), place: Place.examples[0]),
        Record(id: UUID(), type: .cappuccino, size: ._200, price: 7.99, date: Date(timeIntervalSinceNow: -14_400_000), place: Place.examples[1]),
        Record(id: UUID(), type: .flatWhite, size: ._300, price: 2.33, date: Date(timeIntervalSinceNow: -21_600_000), place: Place.examples[2]),
        Record(id: UUID(), type: .macchiato, size: ._400, price: 10.40, date: Date(timeIntervalSinceNow: -28_800_000), place: Place.examples[3]),
        Record(id: UUID(), type: .americano, size: ._150, price: 5.15, date: Date(timeIntervalSinceNow: -36_000_000), place: Place.examples[4]),
        Record(id: UUID(), type: .cappuccino, size: ._100, price: 3.12, date: Date(timeIntervalSinceNow: -43_200_000), place: Place.examples[5]),
        Record(id: UUID(), type: .americano, size: ._200, price: 4.23, date: Date(timeIntervalSinceNow: -50_400_000), place: Place.examples[6]),
        Record(id: UUID(), type: .espresso, size: ._450, price: 12.99, date: Date(timeIntervalSinceNow: -57_600_000), place: Place.examples[7]),
        Record(id: UUID(), type: .cappuccino, size: ._250, price: 3.55, date: Date(timeIntervalSinceNow: -64_800_000), place: Place.examples[8]),
        Record(id: UUID(), type: .latte, size: ._150, price: 6.00, date: Date(timeIntervalSinceNow: -72_000_000), place: Place.examples[9])
    ]
    
    static func threeMonthsExamples() -> [Record]  {
        let threeMonthsAgo = Calendar.current.date(byAdding: .month, value: -3, to: Date())!

        let exampleRecords: [Record] = (1...300).map { _ in
            return Record(
                id: UUID(),
                type: CoffeeType.allCases.randomElement()!,
                size: CoffeeSize.allCases.randomElement()!,
                price: Double.random(in: 1.00...20.00),
                date: Date.random(in: threeMonthsAgo...Date()),
                place: Place.examples.randomElement()!
            )
        }
        
        return exampleRecords.sorted { $0.date < $1.date }
    }
    
//    static func treeMonthsExamples() -> [Record] {
//        let coffeeTypes: [CoffeeType] = CoffeeType.allCases
//        let coffeeSizes: [CoffeeSize] = CoffeeSize.allCases
//
//        var records: [Record] = []
//
//        for _ in 1...30 {
//            let randomPlace = Place.examples.randomElement()!
//            let randomType = coffeeTypes.randomElement()!
//            let randomSize = coffeeSizes.randomElement()!
//            let randomPrice = Double.random(in: 2.5...10.0)
//            let randomDate = Date().addingTimeInterval(-Double.random(in: 0...7776000))
//            
//            let record = Record(
//                id: UUID(),
//                type: randomType,
//                size: randomSize,
//                price: round(randomPrice * 100) / 100,
//                date: randomDate,
//                place: randomPlace
//            )
//            records.append(record)
//        }
//        
//        return records
//    }
}

enum CoffeeType: Int, Identifiable, CaseIterable, Hashable {
    case americano
    case latte
    case cappuccino
    case macchiato
    case flatWhite
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
