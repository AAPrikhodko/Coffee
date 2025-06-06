//
//  DateIntervalPickerView.swift
//  Coffee
//
//  Created by Andrei on 21.05.2025.
//

import SwiftUI

struct DateIntervalPickerView: View {
    let initialStartDate: Date
    let initialEndDate: Date?
    let registrationDate: Date
    var onConfirm: (Date, Date?) -> Void
    
    @Environment(\.dismiss) private var dismiss

    @State private var tempStartDate: Date
    @State private var tempEndDate: Date?
    @State private var activeField: ActiveField = .start
    @State private var currentDate = Date()

    enum ActiveField { case start, end }

    private var calendar: Calendar { .current }
    private var currentYear: Int { calendar.component(.year, from: Date()) }
    private var registrationYear: Int { calendar.component(.year, from: registrationDate) }
    
    @Namespace var scrollAnchor
    
    init(
        initialStartDate: Date,
        initialEndDate: Date?,
        registrationDate: Date,
        onConfirm: @escaping (Date, Date?) -> Void
    ) {
        self.initialStartDate = initialStartDate
        self.initialEndDate = initialEndDate
        self.registrationDate = registrationDate
        self.onConfirm = onConfirm
        _tempStartDate = State(initialValue: initialStartDate)
        _tempEndDate = State(initialValue: initialEndDate)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Close") { dismiss() }
                    Spacer()
                    Text("Select period").font(.headline)
                    Spacer()
                    Button("OK") {
                        onConfirm(tempStartDate, tempEndDate)
                        dismiss()
                    }
                }
                .padding()

                // Поля выбора Start / End
                HStack(spacing: 0) {
                    dateField(
                        title: "Start date",
                        dateText: dateString(tempStartDate),
                        isActive: activeField == .start
                    ) {
                        activeField = .start
                    }

                    dateField(
                        title: "End date",
                        dateText: tempEndDate.map(dateString) ?? "",
                        isActive: activeField == .end
                    ) {
                        activeField = .end
                    }
                }
                .padding(.horizontal)

                // День недели
                HStack {
                    ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) {
                        Text($0)
                            .frame(maxWidth: .infinity)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 8)
                .padding(.horizontal)

                // Скролл месяцев
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(registrationYear...currentYear, id: \.self) { year in
                                ForEach(1...12, id: \.self) { month in
                                    let comps = DateComponents(year: year, month: month)
                                    if let monthDate = calendar.date(from: comps),
                                       monthDate >= registrationDate,
                                       monthDate <= currentDate {
                                        MonthView(
                                            monthDate: monthDate,
                                            tempStartDate: $tempStartDate,
                                            tempEndDate: $tempEndDate,
                                            activeField: $activeField,
                                            registrationDate: registrationDate,
                                            currentDate: currentDate
                                        )
                                        .id(calendar.component(.month, from: monthDate) + calendar.component(.year, from: monthDate) * 100)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .onAppear {
                        let now = Date()
                        let targetID = calendar.component(.month, from: now) + calendar.component(.year, from: now) * 100
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            proxy.scrollTo(targetID, anchor: .top)
                        }
                    }
                }
            }
        }
    }

    func dateString(_ date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "d MMM"
        return df.string(from: date)
    }
}

@ViewBuilder
func dateField(title: String, dateText: String, isActive: Bool, onTap: @escaping () -> Void) -> some View {
    VStack(spacing: 2) {
        Text(title)
            .font(.caption)
            .foregroundStyle(.secondary)
        Text(dateText)
            .frame(minHeight: 20) // Фиксируем высоту
            .onTapGesture { onTap() }
    }
    .frame(maxWidth: .infinity)
    .padding(.bottom, 10)
    .overlay(
        Rectangle()
            .frame(width: 120, height: isActive ? 3 : 1)
            .foregroundColor(isActive ? .blue : .gray.opacity(0.4)),
        alignment: .bottom
    )
}
