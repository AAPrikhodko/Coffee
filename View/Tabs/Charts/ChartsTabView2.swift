//
//  ChartsTabView2.swift
//  Coffee
//
//  Created by Andrei on 20.05.2025.
//

import SwiftUI

struct ChartsTabView2: View {
    enum Measure: String, CaseIterable {
        case spent = "Spent", cups = "Cups", liters = "Liters"
    }

    enum ChartType: String, CaseIterable {
        case bar = "Bar", pie = "Pie"
    }

    enum PeriodStep: String, CaseIterable {
        case week = "Week", month = "Month", year = "Year"
    }

    enum GroupBy: String, CaseIterable {
        case coffeeType = "by Coffee type"
        case country = "by Country"
        case city = "by City"
    }

    @State private var selectedDateRange = Date()...Date()
    @State private var measure: Measure = .spent
    @State private var chartType: ChartType = .bar
    @State private var periodStep: PeriodStep = .month
    @State private var groupBy: GroupBy = .coffeeType
    @State private var selectedFilters: [String] = []
    
    @State private var showDatePicker = false
    @State private var startDate: Date = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
    @State private var endDate: Date? = Date()
    @State private var registrationDate: Date = Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 15))!

    init() {
        let calendar = Calendar.current
        let now = Date()
        if let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: now)) {
            _startDate = State(initialValue: startOfCurrentMonth)
            _endDate = State(initialValue: now)
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // 🔹 Горизонтальный скролл фильтров
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    filterTag(title: formattedPeriod(), removable: false) {
                        showDatePicker = true
                    }
                    .sheet(isPresented: $showDatePicker) {
                        DateIntervalPickerView(
                            startDate: $startDate,
                            endDate: $endDate,
                            isPresented: $showDatePicker,
                            registrationDate: registrationDate
                        )
                    }
                    ForEach(selectedFilters, id: \.self) { filter in
                        filterTag(title: filter)
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Информационный блок + переключатель
            HStack {
                VStack(alignment: .leading) {
                    Text("123")
                        .font(.largeTitle).bold()
                    Text(measure.rawValue)
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 12) {
                    ForEach(Measure.allCases, id: \.self) { m in
                        Image(systemName: icon(for: m))
                            .padding(8)
                            .background(m == measure ? Color.accentColor.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture { measure = m }
                    }
                }
            }
            .padding(.horizontal)

            // 🔹 Карусель графиков
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 280, height: 180)
                            .overlay(Text("Chart \(index + 1)"))
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Переключатели шагов и типа графика
            HStack {
                Picker("Step", selection: $periodStep) {
                    ForEach(PeriodStep.allCases, id: \.self) { step in
                        Text(step.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Picker("Chart", selection: $chartType) {
                    ForEach(ChartType.allCases, id: \.self) { type in
                        Image(systemName: type == .bar ? "chart.bar" : "chart.pie")
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
            .padding(.horizontal)

            // 🔹 Селектор группировки — теперь ближе к списку
            VStack(alignment: .leading, spacing: 0) {
                Picker("Group by", selection: $groupBy) {
                    ForEach(GroupBy.allCases, id: \.self) { group in
                        Text(group.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.bottom, 4) // Минимальный отступ

                // 🔹 Список значений
                List {
                    ForEach(0..<10) { index in
                        Button {
                            addFilter("Value \(index + 1)")
                        } label: {
                            Text("Value \(index + 1)")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .listRowBackground(Color.white) // Убираем стандартную заливку
                    }
                }
                .listStyle(.plain)
                .background(Color.white)
            }
        }
    }

    // MARK: — Вспомогательные функции

    func icon(for m: Measure) -> String {
        switch m {
        case .spent: return "dollarsign.circle"
        case .cups: return "cup.and.saucer"
        case .liters: return "drop"
        }
    }

    func addFilter(_ new: String) {
        if !selectedFilters.contains(new) {
            selectedFilters.append(new)
        }
    }

    func filterTag(title: String, removable: Bool = true, onTap: (() -> Void)? = nil) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(8)
                .onTapGesture {
                    onTap?()
                }
            if removable {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        selectedFilters.removeAll { $0 == title }
                    }
            }
        }
    }
    
    func formattedPeriod() -> String {
        let calendar = Calendar.current
        let nowYear = calendar.component(.year, from: Date())

        let dfShortMonth = DateFormatter()
        dfShortMonth.dateFormat = "MMM"

        let dfFullDayMonth = DateFormatter()
        dfFullDayMonth.dateFormat = "d MMM"

        let dfDayMonthYear = DateFormatter()
        dfDayMonthYear.dateFormat = "d MMM yyyy"

        guard let end = endDate else {
            let year = calendar.component(.year, from: startDate)
            return year == nowYear ? dfFullDayMonth.string(from: startDate)
                                   : dfDayMonthYear.string(from: startDate)
        }

        // Одинаковый день
        if calendar.isDate(startDate, inSameDayAs: end) {
            let year = calendar.component(.year, from: startDate)
            return year == nowYear ? dfFullDayMonth.string(from: startDate)
                                   : dfDayMonthYear.string(from: startDate)
        }

        // Полные месяцы
        let isFullMonths = calendar.isDate(startDate, equalTo: startOfMonth(for: startDate), toGranularity: .day) &&
                           calendar.isDate(end, equalTo: endOfMonth(for: end), toGranularity: .day)

        // Полные годы
        let isFullYears = calendar.isDate(startDate, equalTo: startOfYear(for: startDate), toGranularity: .day) &&
                          calendar.isDate(end, equalTo: endOfYear(for: end), toGranularity: .day)

        let startYear = calendar.component(.year, from: startDate)
        let endYear = calendar.component(.year, from: end)

        let startMonth = dfShortMonth.string(from: startDate)
        let endMonth = dfShortMonth.string(from: end)

        switch (isFullMonths, isFullYears) {
        case (_, true):
            if startYear == endYear {
                return startYear == nowYear ? "Year" : "\(startYear)"
            } else {
                return "\(startYear) - \(endYear)"
            }

        case (true, false):
            if calendar.isDate(startDate, equalTo: end, toGranularity: .month) {
                return startYear == nowYear ? startMonth : "\(startMonth) \(startYear)"
            } else {
                if startYear == endYear {
                    return startYear == nowYear
                        ? "\(startMonth) - \(endMonth)"
                        : "\(startMonth) - \(endMonth), \(startYear)"
                } else {
                    return "\(startMonth) \(startYear) - \(endMonth) \(endYear)"
                }
            }

        case (false, false):
            let startDay = calendar.component(.day, from: startDate)
            let endDay = calendar.component(.day, from: end)

            if calendar.isDate(startDate, equalTo: end, toGranularity: .month) {
                let month = dfShortMonth.string(from: startDate)
                let yearSuffix = startYear != nowYear ? " \(startYear)" : ""
                return "\(startDay) - \(endDay) \(month)\(yearSuffix)"
            } else {
                let startStr = dfFullDayMonth.string(from: startDate)
                let endStr = dfFullDayMonth.string(from: end)

                if startYear == endYear {
                    let year = startYear
                    let suffix = year != nowYear ? " \(year)" : ""
                    return "\(startDay) \(startMonth) - \(endDay) \(endMonth)\(suffix)"
                } else {
                    return "\(startStr) \(startYear) - \(endStr) \(endYear)"
                }
            }
        }
    }



    func startOfMonth(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(for date: Date) -> Date {
        let start = startOfMonth(for: date)
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: start)!
    }

    func startOfYear(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: date))!
    }

    func endOfYear(for date: Date) -> Date {
        let start = startOfYear(for: date)
        return Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: start)!
    }
}
