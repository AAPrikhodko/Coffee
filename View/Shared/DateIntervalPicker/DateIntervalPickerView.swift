//
//  DateIntervalPickerView.swift
//  Coffee
//
//  Created by Andrei on 21.05.2025.
//

import SwiftUI

struct DateIntervalPickerView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date?
    @Binding var isPresented: Bool
    let registrationDate: Date

    @State private var activeField: ActiveField = .start
    @State private var currentDate = Date()

    enum ActiveField { case start, end }

    private var calendar: Calendar { .current }
    private var currentYear: Int { calendar.component(.year, from: Date()) }
    private var registrationYear: Int { calendar.component(.year, from: registrationDate) }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button("Close") { isPresented = false }
                    Spacer()
                    Text("Select period").font(.headline)
                    Spacer()
                    Button("OK") { isPresented = false }
                }
                .padding()

                // Поля выбора Start / End
                HStack(spacing: 0) {
                    VStack {
                        Text("Start date").font(.caption).foregroundStyle(.secondary)
                        Text(dateString(startDate))
                            .onTapGesture { activeField = .start }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: activeField == .start ? 3 : 1)
                            .foregroundColor(activeField == .start ? .blue : .gray.opacity(0.4)),
                        alignment: .bottom
                    )

                    VStack {
                        Text("End date").font(.caption).foregroundStyle(.secondary)
                        if let end = endDate {
                            Text(dateString(end))
                                .onTapGesture { activeField = .end }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 4)
                    .overlay(
                        Rectangle()
                            .frame(height: activeField == .end ? 3 : 1)
                            .foregroundColor(activeField == .end ? .blue : .gray.opacity(0.4)),
                        alignment: .bottom
                    )
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
                                        startDate: $startDate,
                                        endDate: $endDate,
                                        activeField: $activeField,
                                        registrationDate: registrationDate,
                                        currentDate: currentDate
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
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

