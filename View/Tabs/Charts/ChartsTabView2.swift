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

    private let defaultStartDate: Date
    private let defaultEndDate: Date

    @State private var measure: Measure = .spent
    @State private var chartType: ChartType = .bar
    @State private var periodStep: PeriodStep = .month
    @State private var groupBy: GroupBy = .coffeeType
    @State private var selectedFilters: [String] = []

    @State private var showDatePicker = false
    @State private var startDate: Date
    @State private var endDate: Date?
    @State private var registrationDate: Date = Calendar.current.date(from: DateComponents(year: 2023, month: 3, day: 15))!
    @State private var isManualDateChange = false

    init() {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        _startDate = State(initialValue: start)
        _endDate = State(initialValue: now)
        self.defaultStartDate = start
        self.defaultEndDate = now
    }

    var body: some View {
        VStack(spacing: 16) {
            // 🔹 Фильтры
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    periodTag()
                        .sheet(isPresented: $showDatePicker) {
                            DateIntervalPickerView(
                                initialStartDate: startDate,
                                initialEndDate: endDate,
                                registrationDate: registrationDate
                            ) { newStart, newEnd in
                                startDate = newStart
                                endDate = newEnd
                                isManualDateChange = true
                                syncStepWithDates()
                            }
                        }

                    ForEach(selectedFilters, id: \.self) { filter in
                        filterTag(title: filter)
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Информационный блок
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

            // 🔹 Графики
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

            // 🔹 Переключатели
            HStack {
                Picker("Step", selection: $periodStep) {
                    ForEach(PeriodStep.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: periodStep) { newValue in
                    if !isManualDateChange {
                        updateDates(for: newValue)
                    }
                }

                Spacer()

                Picker("Chart", selection: $chartType) {
                    ForEach(ChartType.allCases, id: \.self) {
                        Image(systemName: $0 == .bar ? "chart.bar" : "chart.pie")
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
            .padding(.horizontal)

            // 🔹 Группировка и фильтры
            VStack(alignment: .leading, spacing: 0) {
                Picker("Group by", selection: $groupBy) {
                    ForEach(GroupBy.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.bottom, 4)

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
                        .listRowBackground(Color.white)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onChange(of: startDate) { _ in
            if isManualDateChange {
                isManualDateChange = false
                syncStepWithDates()
            }
        }
        .onChange(of: endDate) { _ in
            if isManualDateChange {
                isManualDateChange = false
                syncStepWithDates()
            }
        }
    }
    
    // MARK: — Синхронизация step <-> dates
    
    func syncStepWithDates() {
        let end = endDate ?? startDate  // если endDate отсутствует — используем startDate
        let days = Calendar.current.dateComponents([.day], from: startDate, to: end).day ?? 0


        if days < 15 {
            periodStep = .week
        } else if days < 84 {
            periodStep = .month
        } else {
            periodStep = .year
        }
    }

    func updateDates(for step: PeriodStep) {
        let calendar = Calendar.current
        let today = Date()
        let end = endDate ?? today
        let maxEnd = min(end, today)

        switch step {
        case .week:
            let weekday = calendar.component(.weekday, from: maxEnd)
            let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - calendar.firstWeekday), to: maxEnd)!
            startDate = calendar.startOfDay(for: startOfWeek)
            endDate = min(calendar.date(byAdding: .day, value: 6, to: startDate)!, today)

        case .month:
            let comps = calendar.dateComponents([.year, .month], from: maxEnd)
            startDate = calendar.date(from: comps)!
            endDate = min(endOfMonth(for: startDate), today)

        case .year:
            let comps = calendar.dateComponents([.year], from: maxEnd)
            startDate = calendar.date(from: comps)!
            endDate = min(endOfYear(for: startDate), today)
        }
    }

    // MARK: — Period Tag

    func periodTag() -> some View {
        let isDefault = Calendar.current.isDate(startDate, inSameDayAs: defaultStartDate) &&
                        endDate != nil &&
                        Calendar.current.isDate(endDate!, inSameDayAs: defaultEndDate)

        return HStack(spacing: 0) {
            HStack(spacing: 6) {
                Text(formattedPeriod())
                    .lineLimit(1)
                    .foregroundColor(.primary)

                Image(systemName: isDefault ? "chevron.down.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        if isDefault {
                            showDatePicker = true
                        } else {
                            startDate = defaultStartDate
                            endDate = defaultEndDate
                        }
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(8)
            .onTapGesture {
                showDatePicker = true
            }
        }
    }



    // MARK: — Helpers

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
        HStack(spacing: 6) {
            HStack(spacing: 6) {
                Text(title)
                    .lineLimit(1)

                if removable {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .onTapGesture {
                            selectedFilters.removeAll { $0 == title }
                        }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.15))
            .cornerRadius(8)
            .onTapGesture {
                onTap?()
            }
        }
    }


    // MARK: — Форматирование периода

    func formattedPeriod() -> String {
        let calendar = Calendar.current
        let today = Date()
        let nowYear = calendar.component(.year, from: today)
        let nowMonth = calendar.component(.month, from: today)

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

        if calendar.isDate(startDate, inSameDayAs: end) {
            let year = calendar.component(.year, from: startDate)
            return year == nowYear ? dfFullDayMonth.string(from: startDate)
                                   : dfDayMonthYear.string(from: startDate)
        }

        let startYear = calendar.component(.year, from: startDate)
        let endYear = calendar.component(.year, from: end)
        let startMonth = calendar.component(.month, from: startDate)

        let isStartOfCurrentMonth = calendar.isDate(startDate, inSameDayAs: startOfMonth(for: today))
        let isEndToday = calendar.isDate(end, inSameDayAs: today)
        let isStartOfCurrentYear = calendar.isDate(startDate, inSameDayAs: startOfYear(for: today))

        // ✅ Специальный случай: текущий месяц (с 1 числа до сегодня)
        if isStartOfCurrentMonth && isEndToday {
            return dfShortMonth.string(from: today) // "May"
        }

        // ✅ Специальный случай: текущий год (с 1 января до сегодня)
        if isStartOfCurrentYear && isEndToday {
            return "\(nowYear)"
        }

        // ⬇️ Остальная логика
        let isFullMonths = calendar.isDate(startDate, equalTo: startOfMonth(for: startDate), toGranularity: .day) &&
                           calendar.isDate(end, equalTo: endOfMonth(for: end), toGranularity: .day)

        let isFullYears = calendar.isDate(startDate, equalTo: startOfYear(for: startDate), toGranularity: .day) &&
                          calendar.isDate(end, equalTo: endOfYear(for: end), toGranularity: .day)

        let startMonthStr = dfShortMonth.string(from: startDate)
        let endMonthStr = dfShortMonth.string(from: end)

        switch (isFullMonths, isFullYears) {
        case (_, true):
            return startYear == endYear
                ? (startYear == nowYear ? "Year" : "\(startYear)")
                : "\(startYear) - \(endYear)"

        case (true, false):
            if calendar.isDate(startDate, equalTo: end, toGranularity: .month) {
                return startYear == nowYear ? startMonthStr : "\(startMonthStr) \(startYear)"
            } else if startYear == endYear {
                return startYear == nowYear
                    ? "\(startMonthStr) - \(endMonthStr)"
                    : "\(startMonthStr) - \(endMonthStr), \(startYear)"
            } else {
                return "\(startMonthStr) \(startYear) - \(endMonthStr) \(endYear)"
            }

        case (false, false):
            let startDay = calendar.component(.day, from: startDate)
            let endDay = calendar.component(.day, from: end)

            if calendar.isDate(startDate, equalTo: end, toGranularity: .month) {
                let yearSuffix = startYear != nowYear ? " \(startYear)" : ""
                return "\(startDay) - \(endDay) \(startMonthStr)\(yearSuffix)"
            } else {
                if startYear == endYear {
                    let suffix = startYear != nowYear ? " \(startYear)" : ""
                    return "\(startDay) \(startMonthStr) - \(endDay) \(endMonthStr)\(suffix)"
                } else {
                    return "\(dfFullDayMonth.string(from: startDate)) \(startYear) - \(dfFullDayMonth.string(from: end)) \(endYear)"
                }
            }
        }
    }


    func startOfMonth(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: date))!
    }

    func endOfMonth(for date: Date) -> Date {
        Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth(for: date))!
    }

    func startOfYear(for date: Date) -> Date {
        Calendar.current.date(from: Calendar.current.dateComponents([.year], from: date))!
    }

    func endOfYear(for date: Date) -> Date {
        Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear(for: date))!
    }
}

