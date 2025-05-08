//
//  StatByExpensesView.swift
//  Coffee
//
//  Created by Andrei on 26.02.2025.
//

//import SwiftUI
//
//struct StatByExpensesView: View {
//    var recordsViewModel: RecordsViewModel
//    
//    var body: some View {
//
//        ScrollView {
//            ForEach(recordsViewModel.records) {record in
//                VStack(alignment: .leading) {
//                    Text("date: \(record.date)")
//                    Text("type: \(record.type)")
//                    Text("price: \(record.price)")
//                }
//                .padding()
//            }
            
//            ForEach(recordsViewModel.recordsByDay, id: \.day) {recordByDay in
//                VStack {
//                    Text("Day: \(recordByDay.day)")
//                    Text("Records: \(recordByDay.records)")
//                }
//                .padding()
//            }
//        }
//    }
//}

import SwiftUI
import Charts

struct StatByExpensesView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    @State private var startDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    @State private var endDate: Date = Date()

    private var interval: DateInterval {
        DateInterval(start: startDate, end: endDate)
    }

    private var data: [(date: Date, total: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: recordsViewModel.records.filter { interval.contains($0.date) }) {
            calendar.startOfDay(for: $0.date)
        }

        let allDates = stride(from: calendar.startOfDay(for: interval.start),
                              through: calendar.startOfDay(for: interval.end),
                              by: 60 * 60 * 24).map { $0 }

        return allDates.map { date in
            let total = grouped[date]?.reduce(0) { $0 + $1.price } ?? 0
            return (date: date, total: total)
        }
    }

    private var statPoints: [StatPoint] {
        data.map { StatPoint(date: $0.date, value: $0.total) }
    }

    private var total: Double {
        data.map(\.total).reduce(0, +)
    }

    private var average: Double {
        guard !data.isEmpty else { return 0 }
        return total / Double(data.count)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Expense Stats")
                    .font(.title2)
                    .fontWeight(.semibold)

                // 🔹 Date pickers
                HStack {
                    DatePicker("From", selection: $startDate, displayedComponents: .date)
                    DatePicker("To", selection: $endDate, displayedComponents: .date)
                }

                // 🔹 Summary
                HStack(spacing: 12) {
                    StatTag(label: "$\(String(format: "%.2f", total)) total", icon: "dollarsign.circle")
                    StatTag(label: "$\(String(format: "%.2f", average)) avg/day", icon: "chart.bar.fill")
                }

                // 🔹 Chart
                Chart(statPoints) {
                    AreaMark(
                        x: .value("Date", $0.date),
                        y: .value("Amount", $0.value)
                    )
                    .foregroundStyle(.linearGradient(
                        Gradient(colors: [Color.accentColor.opacity(0.3), .clear]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))

                    LineMark(
                        x: .value("Date", $0.date),
                        y: .value("Amount", $0.value)
                    )
                    .interpolationMethod(.catmullRom)

                    PointMark(
                        x: .value("Date", $0.date),
                        y: .value("Amount", $0.value)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 7)) { value in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                    }
                }
                .chartYAxis {
                    AxisMarks()
                }
                .frame(height: 200)
            }
            .padding()
        }
        .navigationTitle("By Expenses")
        .navigationBarTitleDisplayMode(.inline)
    }
}
