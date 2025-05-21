//
//  MonthView.swift
//  Coffee
//
//  Created by Andrei on 21.05.2025.
//
import SwiftUI

struct MonthView: View {
    let monthDate: Date
    @Binding var tempStartDate: Date
    @Binding var tempEndDate: Date?
    @Binding var activeField: DateIntervalPickerView.ActiveField

    let registrationDate: Date
    let currentDate: Date

    private var calendar: Calendar { .current }
    private var daysInMonth: [Date] {
        guard let range = calendar.range(of: .day, in: .month, for: monthDate) else { return [] }
        return range.compactMap { day -> Date? in
            let comps = calendar.dateComponents([.year, .month], from: monthDate)
            return calendar.date(from: DateComponents(year: comps.year, month: comps.month, day: day))
        }
    }

    private var isCurrentMonth: Bool {
        calendar.isDate(monthDate, equalTo: currentDate, toGranularity: .month)
    }

    private var startOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: monthDate))!
    }

    private var endOfMonth: Date {
        if isCurrentMonth {
            return currentDate
        } else {
            let comps = DateComponents(month: 1, day: -1)
            return calendar.date(byAdding: comps, to: startOfMonth)!
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                // Выбор месяца полностью
                tempStartDate = startOfMonth
                tempEndDate = endOfMonth
                activeField = .start
            }) {
                Text(monthName(monthDate))
                    .font(.subheadline)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(isWholeMonthSelected ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.primary)
            }

            let firstWeekday = calendar.component(.weekday, from: daysInMonth.first!)
            let prefixEmptyDays = (firstWeekday + 5) % 7 // to start from Monday
            let paddedDays = Array(repeating: nil as Date?, count: prefixEmptyDays) + daysInMonth.map { Optional($0) }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 6) {
                ForEach(paddedDays.indices, id: \.self) { index in
                    if let day = paddedDays[index] {
                        let isDisabled = day < registrationDate || day > currentDate
                        let isInRange = inRange(day)
                        let isStart = calendar.isDate(day, inSameDayAs: tempStartDate)
                        let isEnd = tempEndDate != nil && calendar.isDate(day, inSameDayAs: tempEndDate!)

                        Button(action: {
                            handleSelection(day)
                        }) {
                            Text("\(calendar.component(.day, from: day))")
                                .frame(maxWidth: .infinity, minHeight: 32)
                                .background(
                                    isStart || isEnd
                                    ? Color.blue.opacity(0.2)
                                    : isInRange ? Color.gray.opacity(0.1) : Color.clear
                                )
                                .foregroundColor(isDisabled ? .gray : .primary)
                                .clipShape(Circle())
                        }
                        .disabled(isDisabled)
                    } else {
                        Text("")
                            .frame(maxWidth: .infinity, minHeight: 32)
                    }
                }
            }
        }
    }

    func inRange(_ day: Date) -> Bool {
        if let end = tempEndDate {
            return (tempStartDate...end).contains(day) && !calendar.isDate(day, inSameDayAs: tempStartDate) && !calendar.isDate(day, inSameDayAs: end)
        }
        return false
    }

    func handleSelection(_ day: Date) {
        switch activeField {
        case .start:
            tempStartDate = day
            tempEndDate = nil
            activeField = .end
        case .end:
            if day >= tempStartDate {
                tempEndDate = day
                activeField = .start
            } else {
                tempEndDate = tempStartDate
                tempStartDate = day
                activeField = .start
            }
        }
    }
    
    var isWholeMonthSelected: Bool {
        guard let end = tempEndDate else { return false }
        return calendar.isDate(tempStartDate, equalTo: startOfMonth, toGranularity: .day) &&
               calendar.isDate(end, equalTo: endOfMonth, toGranularity: .day)
    }

    func monthName(_ date: Date) -> String {
        let df = DateFormatter()
        let year = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        df.dateFormat = (year == currentYear) ? "LLLL" : "LLLL yyyy"
        return df.string(from: date)
    }
}

