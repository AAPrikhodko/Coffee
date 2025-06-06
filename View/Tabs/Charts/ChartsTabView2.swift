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
        case coffeeType = "By Coffee"
        case country = "By Country"
        case city = "By City"
    }
    
    @Environment(RecordsViewModel.self) private var recordsViewModel
    
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
    @State private var activeFilters: [Filter] = []

    init() {
        let calendar = Calendar.current
        let now = Date()
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        _startDate = State(initialValue: start)
        _endDate = State(initialValue: now)
        self.defaultStartDate = start
        self.defaultEndDate = now
    }
    
    var totalValue: Double {
        guard let end = endDate else { return 0 }
        let interval = DateInterval(start: startDate, end: end)
        
        var filtered = recordsViewModel.records.filter { interval.contains($0.date) }

        // Фильтрация по активным фильтрам
        for filter in activeFilters {
            switch filter.type {
            case .coffeeType:
                filtered = filtered.filter { $0.drinkType.displayName == filter.value }
            case .country:
                filtered = filtered.filter { $0.place.countryCode == filter.value }
            case .city:
                filtered = filtered.filter { $0.place.cityName == filter.value }
            }
        }

        switch measure {
        case .spent:
            return filtered.map(\.price).reduce(0, +)
        case .cups:
            return Double(filtered.count)
        case .liters:
            return Double(filtered.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
        }
    }

    
    var availableGroupBys: [GroupBy] {
        var result: [GroupBy] = []
        let usedTypes = Set(activeFilters.map { $0.type })

        if !usedTypes.contains(.coffeeType) {
            result.append(.coffeeType)
        }

        if !usedTypes.contains(.country) {
            result.append(.country)
        }

        // Показываем By City только если выбрана ровно одна страна И еще не выбран город
        let selectedCountries = activeFilters.filter { $0.type == .country }
        let selectedCities = activeFilters.filter { $0.type == .city }

        if selectedCountries.count == 1 && selectedCities.isEmpty {
            result.append(.city)
        }

        return result
    }
    
    func groupedItems(for interval: DateInterval) -> [GroupedItem] {
        var filtered = recordsViewModel.records.filter { interval.contains($0.date) }

        for filter in activeFilters {
            switch filter.type {
            case .coffeeType:
                filtered = filtered.filter { $0.drinkType.displayName == filter.value }
            case .country:
                filtered = filtered.filter { $0.place.countryCode == filter.value }
            case .city:
                filtered = filtered.filter { $0.place.cityName == filter.value }
            }
        }

        switch groupBy {
        case .coffeeType:
            let grouped = Dictionary(grouping: filtered, by: \.drinkType)
            let values = grouped.map { (type, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: type.displayName,
                    value: value,
                    percent: 0,
                    icon: type.imageName,
                    color: colorForDrinkType(type)
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }

        case .country:
            let grouped = Dictionary(grouping: filtered) { $0.place.countryCode ?? "?" }
            let values = grouped.map { (country, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: country,
                    value: value,
                    percent: 0,
                    icon: nil,
                    color: colorForCountry(country)
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }

        case .city:
            let grouped = Dictionary(grouping: filtered) { $0.place.cityName ?? "Unknown" }
            let values = grouped.map { (city, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: city,
                    value: value,
                    percent: 0,
                    icon: nil,
                    color: .gray
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }
        }
    }

    func totalValue(for interval: DateInterval) -> Double {
        var filtered = recordsViewModel.records.filter { interval.contains($0.date) }

        for filter in activeFilters {
            switch filter.type {
            case .coffeeType:
                filtered = filtered.filter { $0.drinkType.displayName == filter.value }
            case .country:
                filtered = filtered.filter { $0.place.countryCode == filter.value }
            case .city:
                filtered = filtered.filter { $0.place.cityName == filter.value }
            }
        }

        switch measure {
        case .spent:
            return filtered.map(\.price).reduce(0, +)
        case .cups:
            return Double(filtered.count)
        case .liters:
            return Double(filtered.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
        }
    }


    var body: some View {
        VStack(spacing: 16) {
            filtersSection
            infoSection
            chartSection
            controlsSection
            groupBySelector
            if !availableGroupBys.isEmpty {
                ScrollView {
                    itemsListOrEmptyState
                        .safeAreaInset(edge: .bottom, spacing: 0) {
                            Color.clear.frame(height: 100)
                        }
                }
            } else {
                itemsListOrEmptyState
            }
        }
        .padding(.horizontal)
        .safeAreaInset(edge: .top, spacing: 0) {
            Color.clear.frame(height: 16)
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


    private var filtersSection: some View {
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

                ForEach(activeFilters) { filter in
                    filterTag(filter: filter)
                }
            }
        }
    }
    
    private var infoSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(valueFormatted())
                    .font(.title).bold()
                Text(measure.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
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
    }
    
    private var chartSection: some View {
        DonutChartView(
            items: groupedItems(),
            totalValue: totalValue,
            measure: measure
        )
        .frame(height: 260)
    }
    
    private var controlsSection: some View {
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
    }
    
    private var groupBySelector: some View {
        Group {
            if !availableGroupBys.isEmpty {
                Menu {
                    Picker("Group by", selection: $groupBy) {
                        ForEach(availableGroupBys, id: \.self) { group in
                            Text(group.rawValue)
                        }
                    }
                } label: {
                    HStack {
                        Text(groupBy.rawValue)
                            .font(.headline)
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var itemsListOrEmptyState: some View {
        Group {
            if !availableGroupBys.isEmpty {
                VStack(spacing: 1) {
                    ForEach(groupedItems()) { item in
                        HStack {
                            HStack(spacing: 12) {
                                if let icon = item.icon {
                                    Image(icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 28, height: 28)
                                }
                                Text(item.label)
                                    .font(.body)
                                    .foregroundColor(.primary)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 4) {
                                switch measure {
                                case .spent:
                                    Text(String(format: "%.2f €", item.value))
                                case .cups:
                                    Text("\(Int(item.value)) cups")
                                case .liters:
                                    Text(String(format: "%.1f L", item.value))
                                }
                                Text(String(format: "%.1f%%", item.percent))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onTapGesture {
                            let filter: Filter
                            switch groupBy {
                            case .coffeeType: filter = .init(type: .coffeeType, value: item.label)
                            case .country:    filter = .init(type: .country, value: item.label)
                            case .city:       filter = .init(type: .city, value: item.label)
                            }
                            if !activeFilters.contains(filter) {
                                activeFilters.append(filter)
                                switchToNextGroupBy()
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 12) {
                    Text("No more grouping options")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Try changing filters to see more options.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, minHeight: 275)
            }
        }
    }

    // MARK: — Группировка данных

    func groupedItems() -> [GroupedItem] {
        guard let end = endDate else { return [] }
        let interval = DateInterval(start: startDate, end: end)
        var filtered = recordsViewModel.records.filter { interval.contains($0.date) }

        for filter in activeFilters {
            switch filter.type {
            case .coffeeType:
                filtered = filtered.filter { $0.drinkType.displayName == filter.value }
            case .country:
                filtered = filtered.filter { $0.place.countryCode == filter.value }
            case .city:
                filtered = filtered.filter { $0.place.cityName == filter.value }
            }
        }

        switch groupBy {
        case .coffeeType:
            let grouped = Dictionary(grouping: filtered, by: \.drinkType)
            let values = grouped.map { (type, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: type.displayName,
                    value: value,
                    percent: 0, // updated later
                    icon: type.imageName,
                    color: colorForDrinkType(type)
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }

        case .country:
            let grouped = Dictionary(grouping: filtered) { $0.place.countryCode ?? "?" }
            let values = grouped.map { (country, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: country,
                    value: value,
                    percent: 0,
                    icon: nil,
                    color: colorForCountry(country)
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }

        case .city:
            guard let selectedCountry = activeFilters.first(where: { $0.type == .country }) else {
                return []
            }

            let grouped = Dictionary(grouping: filtered) { $0.place.cityName ?? "Unknown" }
            let values = grouped.map { (city, records) -> GroupedItem in
                let value: Double
                switch measure {
                case .spent:
                    value = records.map(\.price).reduce(0, +)
                case .cups:
                    value = Double(records.count)
                case .liters:
                    value = Double(records.map { $0.drinkSize.rawValue }.reduce(0, +)) / 1000
                }
                return GroupedItem(
                    label: city,
                    value: value,
                    percent: 0,
                    icon: nil,
                    color: .gray
                )
            }
            let total = values.map(\.value).reduce(0, +)
            return values.map {
                GroupedItem(
                    label: $0.label,
                    value: $0.value,
                    percent: total == 0 ? 0 : $0.value / total * 100,
                    icon: $0.icon,
                    color: $0.color
                )
            }.sorted { $0.value > $1.value }
        }
    }

    func colorForDrinkType(_ type: DrinkType) -> Color {
        switch type {
        case .americano: return .brown
        case .latte: return .orange
        case .cappuccino: return .yellow
        case .macchiato: return .purple
        case .flatWhite: return .blue
        case .espresso: return .black
        }
    }

    func colorForCountry(_ code: String) -> Color {
        // Простой маппинг по странам — можно заменить более осмысленным
        switch code.uppercased() {
        case "FR": return .blue
        case "US": return .red
        case "IT": return .green
        case "JP": return .pink
        default: return .gray
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

    func filterTag(filter: Filter) -> some View {
        HStack(spacing: 6) {
            Text(filter.displayValue)
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.gray)
                .onTapGesture {
                    withAnimation {
                        removeFilter(filter)
                    }
                }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.blue.opacity(0.15))
        .cornerRadius(8)
    }
    
    func removeFilter(_ filter: Filter) {
        activeFilters.removeAll { $0 == filter }

        // Если удалили страну — удаляем все фильтры по городам
        if filter.type == .country {
            activeFilters.removeAll { $0.type == .city }
        }

        // Обновляем groupBy, если выбранное значение больше не доступно
        if !availableGroupBys.contains(groupBy), let fallback = availableGroupBys.first {
            groupBy = fallback
        }
    }
    
    func switchToNextGroupBy() {
        let remaining = availableGroupBys
        if let next = remaining.first(where: { $0 != groupBy }) {
            groupBy = next
        }
    }

    func restoreGroupBy(for filter: Filter) {
        switch filter.type {
        case .coffeeType:
            if !availableGroupBys.contains(.coffeeType) {
                groupBy = .coffeeType
            }
        case .country:
            if !availableGroupBys.contains(.country) {
                groupBy = .country
            }
        case .city:
            if !availableGroupBys.contains(.city) {
                groupBy = .city
            }

        }
    }


    // MARK: — Форматирование периода

    func formattedPeriod() -> String {
        let calendar = Calendar.current
        let today = Date()
        let nowYear = calendar.component(.year, from: today)

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
    
    func valueFormatted() -> String {
        switch measure {
        case .spent:
            return String(format: "%.2f €", totalValue)
        case .cups:
            return "\(Int(totalValue))"
        case .liters:
            return String(format: "%.1f", totalValue)
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

// MARK: - ItemModel для списка
struct GroupedItem: Identifiable {
    var id: String { label }
    let label: String
    let value: Double
    let percent: Double
    let icon: String?
    let color: Color
}

struct ChartPeriodItem: Identifiable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let items: [GroupedItem]
    let total: Double
}
