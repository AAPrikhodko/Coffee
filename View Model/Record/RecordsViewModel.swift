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


    var totalRecordsPerDrinkType: [(drinkType: DrinkType, records: Int)] {
        let recordsByDrinkType = recordsGroupedByDrinkType(records: records)
        let totalRecordsPerDrinkType = totalRecordsPerDrinkType(recordsByCoffeType: recordsByDrinkType)
        return totalRecordsPerDrinkType.sorted { $0.records > $1.records }
    }
  
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
    
    // MARK: - Гео-статистика

    var totalCups: Int {
        records.count
    }

    var uniqueCities: Int {
        Set(records.map { $0.place.cityName }).count
    }

    var uniqueCountries: Int {
        Set(records.map { $0.place.countryCode ?? "?" }).count
    }

    var favoriteCity: String? {
        records.group { $0.place.cityName }
            .max(by: { $0.value.count < $1.value.count })?.key
    }

    var favoriteCountry: String? {
        records.group { $0.place.countryCode ?? "?" }
            .max(by: { $0.value.count < $1.value.count })?.key
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
    
    var availableCountries: [String] {
        Set(records.compactMap { $0.place.countryCode }).sorted()
    }

    func cities(in country: String?) -> [String] {
        let filtered = country == nil
            ? records
            : records.filter { $0.place.countryCode == country }
        return Set(filtered.map { $0.place.cityName }).sorted()
    }

    func filteredRecords(country: String?, city: String?) -> [Record] {
        records.filter { record in
            let matchesCountry = country == nil || record.place.countryCode == country
            let matchesCity = city == nil || record.place.cityName == city
            return matchesCountry && matchesCity
        }
    }

    // MARK: - Aggregated Geo Stats

    struct GeoStats {
        let totalCups: Int
        let cityCount: Int
        let countryCount: Int
        let favoriteDrink: DrinkType?
        let totalExpenses: Double
        let averagePrice: Double
        let mostExpensive: Record?
        let cheapest: Record?
    }

    func geoStats(for records: [Record]) -> GeoStats {
        let cups = records.count
        let cities = Set(records.map { $0.place.cityName }).count
        let countries = Set(records.map { $0.place.countryCode ?? "?" }).count

        let drinkCounts = Dictionary(grouping: records, by: \.drinkType)
            .mapValues { $0.count }
        let favoriteDrink = drinkCounts.max { $0.value < $1.value }?.key

        let totalSpent = records.map(\.price).reduce(0, +)
        let averagePrice = records.isEmpty ? 0 : totalSpent / Double(records.count)

        let mostExpensive = records.max { $0.price < $1.price }
        let cheapest = records.min { $0.price < $1.price }

        return GeoStats(
            totalCups: cups,
            cityCount: cities,
            countryCount: countries,
            favoriteDrink: favoriteDrink,
            totalExpenses: totalSpent,
            averagePrice: averagePrice,
            mostExpensive: mostExpensive,
            cheapest: cheapest
        )
    }
    
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
