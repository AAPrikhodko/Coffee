//
//  CalendarTabView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUI

struct CalendarTabView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    @State private var selectedDate: Date? = nil
    @State private var currentMonth: Date = Date()

    private let calendar = Calendar.current

    private var recordedDates: Set<Date> {
        Set(recordsViewModel.records.map { calendar.startOfDay(for: $0.date) })
    }

    private var visibleRecords: [Record] {
        if let selected = selectedDate {
            return recordsViewModel.records.filter {
                calendar.isDate($0.date, inSameDayAs: selected)
            }
        } else {
            return recordsViewModel.records.filter {
                calendar.isDate($0.date, equalTo: currentMonth, toGranularity: .month)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // 🔹 Header
                HStack {
                    Button {
                        withAnimation {
                            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    Text(monthYearFormatter.string(from: currentMonth))
                        .font(.headline)

                    Spacer()

                    Button {
                        withAnimation {
                            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                }

                // 🔹 Calendar grid
                CalendarMonthGridView(
                    month: currentMonth,
                    selectedDate: selectedDate,
                    datesWithRecords: recordedDates,
                    onSelect: { date in
                        guard let date else {
                            selectedDate = nil
                            return
                        }

                        let isInCurrentMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        if !isInCurrentMonth {
                            withAnimation(.easeInOut) {
                                currentMonth = date
                            }
                        }

                        selectedDate = date
                    }
                )

                // 🔹 Records
                if visibleRecords.isEmpty {
                    ContentUnavailableView("No records", systemImage: "calendar.badge.exclamation")
                } else {
                    List(visibleRecords) { record in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(record.drinkType.displayName)
                                .font(.headline)
                            Text(record.place.address)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Calendar")
        }
    }

    private var monthYearFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }
}

#Preview {
    CalendarTabView()
}
