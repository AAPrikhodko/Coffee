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
            VStack(spacing: 8) {
                // Header
                HStack {
                    Button("Close") { isPresented = false }
                    Spacer()
                    Text("Select period").font(.headline)
                    Spacer()
                    Button("OK") { isPresented = false }
                }
                .padding()

                // Start / End date fields
                HStack {
                    VStack {
                        Text("Start date")
                            .foregroundStyle(.secondary)
                        Text(dateString(startDate))
                            .fontWeight(activeField == .start ? .bold : .regular)
                            .underline(activeField == .start)
                            .onTapGesture { activeField = .start }
                    }
                    Spacer()
                    VStack {
                        Text("End date")
                            .foregroundStyle(.secondary)
                        Text(endDate.map(dateString) ?? "—")
                            .fontWeight(activeField == .end ? .bold : .regular)
                            .underline(activeField == .end)
                            .onTapGesture { activeField = .end }
                    }
                }
                .padding(.horizontal)

                // Weekday row
                HStack {
                    ForEach(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], id: \.self) { day in
                        Text(day).frame(maxWidth: .infinity)
                            .font(.caption).foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 6)

                // Scroll of months
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(registrationYear...currentYear, id: \.self) { year in
                            ForEach(1...12, id: \.self) { month in
                                let components = DateComponents(year: year, month: month)
                                if let monthDate = calendar.date(from: components),
                                   monthDate >= calendar.startOfDay(for: registrationDate),
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
