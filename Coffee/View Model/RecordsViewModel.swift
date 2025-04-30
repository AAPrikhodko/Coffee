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
      var records: [Record] = []
//    var records = Record.threeMonthsExamples()
//    var records = Record.examples
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
    
    var expensesByMonth: [ExpenseStates] {
        let recordsByMonth = recordsGroupedByMonth(records: records)
        let expensesByMonth = totalExpensesPerDate(recordsByDate: recordsByMonth)
        return expensesByMonth.sorted { $0.day < $1.day }
    }
    
    var totalExpenses: Double {
        return records.reduce(0) { $0 + $1.price }
    }
    
    var totalRecordsPerDrinkType: [(drinkType: DrinkType, records: Int)] {
        let recordsByDrinkType = recordsGroupedByDrinkType(records: records)
        let totalRecordsPerDrinkType = totalRecordsPerDrinkType(recordsByCoffeType: recordsByDrinkType)
        return totalRecordsPerDrinkType.sorted { $0.records > $1.records }
    }
    
    var favouriteDrinkType: (drinkType: DrinkType, records: Int)? {
        totalRecordsPerDrinkType.max { $0.records < $1.records }
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
    
    func totalExpensesPerDate(recordsByDate: [Date: [Record]]) -> [ExpenseStates] {
        var totalExpenses: [ExpenseStates] = []
        
        for (date, records) in recordsByDate {
            let totalExpensesForDate = records.reduce(0) { $0 + $1.price }
            let newTotalExpensesForDate = ExpenseStates(day: date, expenses: totalExpensesForDate)
        
            totalExpenses.append(newTotalExpensesForDate)
        }
        
        return totalExpenses
    }
    
    func recordsGroupedByDrinkType(records: [Record]) -> [DrinkType: [Record]] {
        var recordsByDrinkType: [DrinkType: [Record]] = [:]

        for record in records {
            let drinkType = record.drinkType
            if recordsByDrinkType[drinkType] != nil {
                recordsByDrinkType[drinkType]!.append(record)
            } else {
                recordsByDrinkType[drinkType] = [record]
            }
        }

        return recordsByDrinkType
    }
    
    func totalRecordsPerDrinkType(recordsByCoffeType: [DrinkType: [Record]]) -> [(drinkType: DrinkType, records: Int)] {
        var totalRecords: [(drinkType: DrinkType, records: Int)] = []

        for (drinkType, records) in recordsByCoffeType {
            totalRecords.append((drinkType: drinkType, records: records.count))
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

struct ExpenseStates: Identifiable {
    var day: Date
    var expenses: Double
    
    var id: Date { day }
}
