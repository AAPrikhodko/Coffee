//
//  PreviewStatByExpensesView.swift
//  Coffee
//
//  Created by Andrei on 20.02.2025.
//

import SwiftUI
import Charts

struct PreviewStatByExpensesView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Your total expenses for the last year are ") +
            Text("$\(String(format: "%.2f", recordsViewModel.totalExpenses)).")
                .bold()
                .foregroundColor(Color.pink)
            Chart {
                Plot {
                    ForEach(recordsViewModel.expensesByMonth) { expenseData in
                        LineMark(x: .value("Date", expenseData.day),
                                 y: .value("Expense", expenseData.expenses))
                    }
                }
                .interpolationMethod(.linear)
                .foregroundStyle(.pink)
            }
//            .chartXAxis(.hidden)
//            .chartYAxis(.hidden)
            .chartLegend(.hidden)
//            .chartXScale(domain: 1...12)
            
            .frame(height: 70)
        }
    }
}
