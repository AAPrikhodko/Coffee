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
    var records = Record.threeMonthsExamples()
//    [
//        Record(
//            id: UUID(),
//            type: .americano,
//            size: ._300,
//            price: 10,
//            date: Date(),
//            place: Place(
//                id: UUID(),
//                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
//                address: "",
//                type: .cafe
//            )
//        ),
//        Record(
//            id: UUID(),
//            type: .cappuccino,
//            size: ._200,
//            price: 12.99,
//            date: Date(),
//            place: Place(
//                id: UUID(),
//                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
//                address: "",
//                type: .cafe
//            )
//        ),
//        Record(
//            id: UUID(),
//            type: .espresso,
//            size: ._100,
//            price: 7.55,
//            date: Date(),
//            place: Place(
//                id: UUID(),
//                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
//                address: "",
//                type: .hotel
//            )
//        ),
//        Record(
//            id: UUID(),
//            type: .latte,
//            size: ._400,
//            price: 15.00,
//            date: Date(),
//            place: Place(
//                id: UUID(),
//                location: CLLocation(latitude: 37.7749, longitude: -122.4194),
//                address: "",
//                type: .hotel
//            )
//        ),
//    ]
    
    

    var totalRecords: Int {
        return records.count
    }
    
    var lastTotalRecords: Int = 270
    
    var recordsByDay: [(day: Date, records: Int)] {
        let recordsByDay = recordsGroupedByDay(records: records)
        return totalRecordsPerDate(recordsByDate: recordsByDay)
    }
    
    var recordsByWeek:[(day: Date, records: Int)] {
        let recordsByWeek = recordsGroupedByWeek(records: records)
        return totalRecordsPerDate(recordsByDate: recordsByWeek)
    }
    
    var recordsByMonth: [(day: Date, records: Int)] {
        let recordsByMonth = recordsGroupedByMonth(records: records)
        return totalRecordsPerDate(recordsByDate: recordsByMonth)
    }
    
    var totalSpent: Double {
        return records.reduce(0) { $0 + $1.price }
    }
    
    var totalRecordsPerCoffeeType: [(coffeeType: CoffeeType, records: Int)] {
        let recordsByCoffeeType = recordsGroupedByCoffeeType(records: records)
        let totalRecordsPerCoffeeType = totalRecordsPerCoffeeType(recordsByCoffeType: recordsByCoffeeType)
        return totalRecordsPerCoffeeType.sorted { $0.records > $1.records }
    }
    
    var favouriteCoffeeType: (coffeeType: CoffeeType, records: Int)? {
        totalRecordsPerCoffeeType.max { $0.records < $1.records }
    }
    
    init() {
        // get records
    }
    
    func recordsGroupedByDay(records: [Record]) -> [Date: [Record]] {
        var recordsByDay: [Date: [Record]] = [:]
        
        let calendar = Calendar.current
        for record in records {
            let date = calendar.startOfDay(for: record.date) // get start of the day for the sale date
            if recordsByDay[date] != nil {
                recordsByDay[date]!.append(record)
            } else {
                recordsByDay[date] = [record]
            }
        }
        
        return recordsByDay
    }
    
    func recordsGroupedByWeek(records: [Record]) -> [Date: [Record]] {
        var recordsByWeek: [Date: [Record]] = [:]
        
        let calendar = Calendar.current
        for record in records {
            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: record.date)) else { continue }
            if recordsByWeek[startOfWeek] != nil {
                recordsByWeek[startOfWeek]!.append(record)
            } else {
                recordsByWeek[startOfWeek] = [record]
            }
        }
        
        return recordsByWeek
    }
    
    func recordsGroupedByMonth(records: [Record]) -> [Date: [Record]] {
        var recordsByMonth: [Date: [Record]] = [:]
        
        let calendar = Calendar.current
        for record in records {
            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.month], from: record.date)) else { continue }
            if recordsByMonth[startOfMonth] != nil {
                recordsByMonth[startOfMonth]!.append(record)
            } else {
                recordsByMonth[startOfMonth] = [record]
            }
        }
        
        return recordsByMonth
    }
    
    func totalRecordsPerDate(recordsByDate: [Date: [Record]]) -> [(day: Date, records: Int)] {
        var totalRecords: [(day: Date, records: Int)] = []
        
        for (date, records) in recordsByDate {
            totalRecords.append((day: date, records: records.count))
        }
        
        return totalRecords
    }
    
    func recordsGroupedByCoffeeType(records: [Record]) -> [CoffeeType: [Record]] {
        var recordsByCoffeeType: [CoffeeType: [Record]] = [:]

        for record in records {
            let cofeeType = record.type
            if recordsByCoffeeType[cofeeType] != nil {
                recordsByCoffeeType[cofeeType]!.append(record)
            } else {
                recordsByCoffeeType[cofeeType] = [record]
            }
        }

        return recordsByCoffeeType
    }
    
    func totalRecordsPerCoffeeType(recordsByCoffeType: [CoffeeType: [Record]]) -> [(coffeeType: CoffeeType, records: Int)] {
        var totalRecords: [(coffeeType: CoffeeType, records: Int)] = []

        for (coffeeType, records) in recordsByCoffeType {
            totalRecords.append((coffeeType: coffeeType, records: records.count))
        }

        return totalRecords
    }
    
    static var preview: RecordsViewModel {
        let vm = RecordsViewModel()
        vm.records = Record.threeMonthsExamples()
        
        return vm
    }
    
    func addRecord(_ record: Record) {
        records.append(record)
    }
}
