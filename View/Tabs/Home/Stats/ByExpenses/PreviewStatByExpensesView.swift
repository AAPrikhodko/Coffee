//
//  PreviewStatByExpensesView.swift
//  Coffee
//
//  Created by Andrei on 20.02.2025.
//

//import SwiftUI
//import Charts
//
//struct PreviewStatByExpensesView: View {
//    var recordsViewModel: RecordsViewModel
//    
//    var body: some View {
//        Text("Hello from settings tab!")
//        VStack(alignment: .leading) {
//            
//            Text("Your total expenses for the last year are ") +
//            Text("$\(String(format: "%.2f", recordsViewModel.totalExpenses)).")
//                .bold()
//                .foregroundColor(Color.pink)
//            Chart {
//                Plot {
//                    ForEach(recordsViewModel.expensesByMonth) { expenseData in
//                        LineMark(x: .value("Date", expenseData.day),
//                                 y: .value("Expense", expenseData.expenses))
//                    }
//                }
//                .interpolationMethod(.linear)
//                .foregroundStyle(.pink)
//            }
////            .chartXAxis(.hidden)
////            .chartYAxis(.hidden)
//            .chartLegend(.hidden)
////            .chartXScale(domain: 1...12)
//            
//            .frame(height: 70)
//        }
//    }
//}
import SwiftUI
import Charts

struct PreviewStatByExpensesView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    private var data: [MonthlyExpense] {
        recordsViewModel.expensesByMonth.suffix(3)
    }

    private var total: Double {
        data.map(\.total).reduce(0, +)
    }

    private var trend: String {
        let last = data.last?.total ?? 0
        let prev = data.dropLast().last?.total ?? 0
        guard prev > 0 else { return "+100%" }
        let change = ((last - prev) / prev) * 100
        return String(format: "%+.0f%%", change)
    }

    private var trendColor: Color {
        if trend.hasPrefix("+") { return .green }
        if trend.hasPrefix("-") { return .red }
        return .gray
    }

    private var statPoints: [StatPoint] {
        data.map { StatPoint(date: $0.month, value: $0.total) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("$\(String(format: "%.2f", total))")
                    .fontWeight(.semibold)
                Spacer()
                Text("Expenses")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text("Last 3 months: \(trend)")
                .font(.caption2)
                .foregroundColor(trendColor)

            Chart(statPoints) {
                AreaMark(
                    x: .value("Month", $0.date),
                    y: .value("Total", $0.value)
                )
                .foregroundStyle(.linearGradient(
                    Gradient(colors: [Color.accentColor.opacity(0.3), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                ))

                LineMark(
                    x: .value("Month", $0.date),
                    y: .value("Total", $0.value)
                )
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Month", $0.date),
                    y: .value("Total", $0.value)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.narrow))
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 50)
        }
        .padding(.vertical, 8)
    }
}

