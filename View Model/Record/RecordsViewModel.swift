//
//  CoffeeViewModel.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation
import CoreLocation
import MapKit
import FirebaseAuth
import SwiftUI

@Observable
class RecordsViewModel {
    private let recordRepository: RecordRepository = FirebaseRecordRepository()
    
    var records: [Record] = []
    var userId: UUID

    init(user: User) {
        self.userId = user.id
        Task {
            await loadRecords()
        }
    }

//    var totalRecords: Int {
//        return records.count
//    }
//    
//    var lastTotalRecords: Int = 270
//    
//    var recordsByDay: [(day: Date, records: Int)] {
//        let recordsByDay = recordsGroupedByDay(records: records)
//        return totalRecordsPerDate(recordsByDate: recordsByDay)
//    }
//    
//    var recordsByWeek:[(day: Date, records: Int)] {
//        let recordsByWeek = recordsGroupedByWeek(records: records)
//        return totalRecordsPerDate(recordsByDate: recordsByWeek)
//    }
//    
//    var recordsByMonth: [(day: Date, records: Int)] {
//        let recordsByMonth = recordsGroupedByMonth(records: records)
//        return totalRecordsPerDate(recordsByDate: recordsByMonth)
//    }
//    
//    var expensesByMonth: [ExpenseStates] {
//        let recordsByMonth = recordsGroupedByMonth(records: records)
//        let expensesByMonth = totalExpensesPerDate(recordsByDate: recordsByMonth)
//        return expensesByMonth.sorted { $0.day < $1.day }
//    }
//    
//    var totalExpenses: Double {
//        return records.reduce(0) { $0 + $1.price }
//    }
//    
    var totalRecordsPerDrinkType: [(drinkType: DrinkType, records: Int)] {
        let recordsByDrinkType = recordsGroupedByDrinkType(records: records)
        let totalRecordsPerDrinkType = totalRecordsPerDrinkType(recordsByCoffeType: recordsByDrinkType)
        return totalRecordsPerDrinkType.sorted { $0.records > $1.records }
    }
//    
    var favouriteDrinkType: (drinkType: DrinkType, records: Int)? {
        totalRecordsPerDrinkType.max { $0.records < $1.records }
    }
    
    var drinkStats: [DrinkTypeStats] {
        let grouped = Dictionary(grouping: records, by: \.drinkType)
        return grouped.map { (key, values) in
            DrinkTypeStats(type: key, count: values.count)
        }
        .sorted { $0.count > $1.count }
    }
    
    var expensesByMonth: [MonthlyExpense] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: records) {
            calendar.date(from: calendar.dateComponents([.year, .month], from: $0.date)) ?? $0.date
        }

        return grouped.map { (key, values) in
            MonthlyExpense(month: key, total: values.reduce(0) { $0 + $1.price })
        }
        .sorted { $0.month < $1.month }
    }

    // MARK: - Универсальная группировка по дате
    func records(for interval: DateInterval) -> [(date: Date, count: Int)] {
        groupRecords(in: interval)
    }

    private func groupRecords(in interval: DateInterval) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: records.filter { interval.contains($0.date) }) {
            calendar.startOfDay(for: $0.date)
        }

        let allDates = stride(
            from: calendar.startOfDay(for: interval.start),
            to: calendar.startOfDay(for: interval.end),
            by: 60 * 60 * 24
        ).map { calendar.startOfDay(for: $0) }

        return allDates.map { date in
            (date: date, count: grouped[date]?.count ?? 0)
        }
    }
    
    func recordsGroupedByDay(forLast days: Int) -> [(date: Date, count: Int)] {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(byAdding: .day, value: -days, to: now)!
        let interval = DateInterval(start: calendar.startOfDay(for: start), end: calendar.startOfDay(for: now))
        return groupRecords(in: interval)
    }
    
//    func recordsGroupedByDay(records: [Record]) -> [Date: [Record]] {
//        var recordsByDay: [Date: [Record]] = [:]
//        
//        let calendar = Calendar.current
//        for record in records {
//            let date = calendar.startOfDay(for: record.date) // get start of the day for the sale date
//            if recordsByDay[date] != nil {
//                recordsByDay[date]!.append(record)
//            } else {
//                recordsByDay[date] = [record]
//            }
//        }
//        
//        return recordsByDay
//    }
//    
//    func recordsGroupedByWeek(records: [Record]) -> [Date: [Record]] {
//        var recordsByWeek: [Date: [Record]] = [:]
//        
//        let calendar = Calendar.current
//        for record in records {
//            guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: record.date)) else { continue }
//            if recordsByWeek[startOfWeek] != nil {
//                recordsByWeek[startOfWeek]!.append(record)
//            } else {
//                recordsByWeek[startOfWeek] = [record]
//            }
//        }
//        
//        return recordsByWeek
//    }
//    
//    func recordsGroupedByMonth(records: [Record]) -> [Date: [Record]] {
//        var recordsByMonth: [Date: [Record]] = [:]
//        
//        let calendar = Calendar.current
//        for record in records {
//            guard let startOfMonth = calendar.date(from: calendar.dateComponents([.month], from: record.date)) else { continue }
//            if recordsByMonth[startOfMonth] != nil {
//                recordsByMonth[startOfMonth]!.append(record)
//            } else {
//                recordsByMonth[startOfMonth] = [record]
//            }
//        }
//        
//        return recordsByMonth
//    }
//    
//    func totalRecordsPerDate(recordsByDate: [Date: [Record]]) -> [(day: Date, records: Int)] {
//        var totalRecords: [(day: Date, records: Int)] = []
//        
//        for (date, records) in recordsByDate {
//            totalRecords.append((day: date, records: records.count))
//        }
//        
//        return totalRecords
//    }
//    
//    func totalExpensesPerDate(recordsByDate: [Date: [Record]]) -> [ExpenseStates] {
//        var totalExpenses: [ExpenseStates] = []
//        
//        for (date, records) in recordsByDate {
//            let totalExpensesForDate = records.reduce(0) { $0 + $1.price }
//            let newTotalExpensesForDate = ExpenseStates(day: date, expenses: totalExpensesForDate)
//        
//            totalExpenses.append(newTotalExpensesForDate)
//        }
//        
//        return totalExpenses
//    }
//    
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
    
//    func recordsGroupedByLocation(precision: Int = 3) -> [Cluster] {
//        let factor = pow(10.0, Double(precision))
//
//        var grouped: [String: [Record]] = [:]
//
//        for record in records {
//            guard let coords = record.place.coordinates else { continue }
//            let lat = round(coords.latitude * factor) / factor
//            let lon = round(coords.longitude * factor) / factor
//            let key = "\(lat)-\(lon)"
//            grouped[key, default: []].append(record)
//        }
//
//        return grouped.map { key, records in
//            guard let first = records.first?.place.coordinates else {
//                return Cluster(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), records: records)
//            }
//            return Cluster(coordinate: CLLocationCoordinate2D(latitude: first.latitude, longitude: first.longitude), records: records)
//        }
//    }


    
    func loadRecords() async {
        do {
            let fetched = try await recordRepository.fetchRecords(for: userId)
            self.records = fetched
            print("✅ Loaded records: \(fetched.count)")
        } catch {
            print("❌ Failed to load records: \(error.localizedDescription)")
        }
    }

    func addRecord(_ record: Record) async throws {
        try await recordRepository.addRecord(record)
        self.records.append(record)
    }
    
    func deleteRecord(_ record: Record) async throws {
        try await recordRepository.deleteRecord(record.id)
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records.remove(at: index)
        }
    }
    
    func updateRecord(_ updated: Record) async throws {
        try await recordRepository.updateRecord(updated)

        if let index = records.firstIndex(where: { $0.id == updated.id }) {
            records[index] = updated
        }
    }
    
    func reset(for newUserId: UUID) {
        self.userId = newUserId
        Task {
            await loadRecords()
        }
    }
}

struct ExpenseStates: Identifiable {
    var day: Date
    var expenses: Double
    
    var id: Date { day }
}
