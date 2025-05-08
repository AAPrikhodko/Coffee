//
//  CalendarMonthGridView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUI

struct CalendarMonthGridView: View {
    let month: Date
    let selectedDate: Date?
    let datesWithRecords: Set<Date>
    let onSelect: (Date?) -> Void

    private let calendar = Calendar.current

    private var days: [Date] {
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: month)),
              let range = calendar.range(of: .day, in: .month, for: month),
              let monthEnd = calendar.date(byAdding: .day, value: range.count - 1, to: monthStart)
        else { return [] }

        // Начало недели для первого дня месяца
        let firstVisible = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: monthStart))!

        // Конец недели для последнего дня месяца (воскресенье)
        let weekday = calendar.component(.weekday, from: monthEnd)
        let daysToAdd = 7 - ((weekday - calendar.firstWeekday + 7) % 7) - 1
        let lastVisible = calendar.date(byAdding: .day, value: daysToAdd, to: monthEnd)!

        return stride(from: firstVisible, through: lastVisible, by: 60 * 60 * 24).map { $0 }
    }

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(days, id: \.self) { day in
                Button {
                    let dayStart = calendar.startOfDay(for: day)
                    let selectedStart = selectedDate.map { calendar.startOfDay(for: $0) }

                    // Смена месяца, если день не в текущем
                    if !calendar.isDate(day, equalTo: month, toGranularity: .month) {
                        onSelect(dayStart) // уже внутри CalendarTabView будет scroll
                    } else if dayStart == selectedStart {
                        onSelect(nil)
                    } else {
                        onSelect(dayStart)
                    }
                } label: {
                    CalendarDayView(
                        date: day,
                        isSelected: selectedDate.map { calendar.isDate($0, inSameDayAs: day) } ?? false,
                        isToday: calendar.isDateInToday(day),
                        isInCurrentMonth: calendar.isDate(day, equalTo: month, toGranularity: .month),
                        hasRecord: datesWithRecords.contains(calendar.startOfDay(for: day))
                    )
                }
            }
        }
    }
}
