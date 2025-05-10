//
//  CalendarTabView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUI

struct CalendarTabView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel
    @Environment(AuthViewModel.self) var authViewModel

    @State private var selectedDate: Date? = nil
    @State private var currentMonth: Date = Date()
    @State private var selectedRecord: Record? = nil
    @State private var isEditingSheetShown = false
    @State private var showDeleteConfirmation = false
    @State private var recordToDelete: Record? = nil
    @State private var showAddRecordSheet = false

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

                // 🔹 Records list
                if visibleRecords.isEmpty {
                    ContentUnavailableView("No records", systemImage: "calendar.badge.exclamation")
                } else {
                    List(visibleRecords) { record in
                        RecordRowView(
                            record: record,
                            onEdit: {
                                selectedRecord = record
                                isEditingSheetShown = true
                            },
                            onDelete: {
                                recordToDelete = record
                                showDeleteConfirmation = true
                            }
                        )
                    }
                    .listStyle(.plain)
                }

                // 🔹 Add Record Button
                AddDrinkButton(
                    showSheet: $showAddRecordSheet
                )
                .padding(.bottom, 10)
                .padding(.leading, 6)
            }
            .padding()
            .navigationTitle("Calendar")
            .sheet(isPresented: $isEditingSheetShown) {
                if let record = selectedRecord {
                    AddRecordView(
                        isSheetShown: $isEditingSheetShown,
                        authViewModel: authViewModel,
                        recordsViewModel: recordsViewModel,
                        editingRecord: record
                    )
                }
            }
            .sheet(isPresented: $showAddRecordSheet) {
                AddRecordView(
                    isSheetShown: $showAddRecordSheet,
                    authViewModel: authViewModel,
                    recordsViewModel: recordsViewModel,
                    defaultDate: selectedDate ?? Date()
                )
            }
            .alert("Delete record?", isPresented: $showDeleteConfirmation, presenting: recordToDelete) { record in
                Button("Delete", role: .destructive) {
                    Task {
                        try? await recordsViewModel.deleteRecord(record)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("This action cannot be undone.")
            }
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
