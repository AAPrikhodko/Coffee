//
//  StatByCoffeeTypeBarChartView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI
import Charts

struct StatByCoffeeTypeBarChartView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        Chart(recordsViewModel.totalRecordsPerCoffeeType, id: \.coffeeType) { data in
            BarMark(
                x: .value("records", data.records),
                y: .value("Coffee Type", data.coffeeType.title)
            )
            .annotation(position: .trailing, alignment: .leading, content: {
                Text("\(data.records)")
                    .opacity(data.coffeeType == recordsViewModel.favouriteCoffeeType?.coffeeType ? 1 : 0.3)
            })
            .opacity(data.coffeeType == recordsViewModel.favouriteCoffeeType?.coffeeType ? 1 : 0.3)
            .foregroundStyle(by: .value("Coffee Type", data.coffeeType.title))
        }
        .chartLegend(.hidden)
        .frame(maxHeight: 400)
    }
}

#Preview {
    StatByCoffeeTypeBarChartView(recordsViewModel: .preview)
        .padding()
}
