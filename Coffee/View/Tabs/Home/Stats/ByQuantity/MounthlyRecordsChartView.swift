//
//  MounthlyRecordsChartsView.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import SwiftUI
import Charts

struct MounthlyRecordsChartsView: View {
    let recordsData: [Record]
    
    var body: some View {
        Chart(recordsData) { record in
            BarMark(
                x: .value("Month", record.date, unit: .month),
                y: .value("Records", record.price)
            )
        }
    }
}

#Preview {
    MounthlyRecordsChartsView(recordsData: Record.threeMonthsExamples())
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
