//
//  StatByDrinkTypeBarChartView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI
import Charts

struct StatByDrinkTypeBarChartView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        Text("Hello from settings tab!")
//        Chart(recordsViewModel.totalRecordsPerDrinkType, id: \.drinkType) { data in
//            BarMark(
//                x: .value("records", data.records),
//                y: .value("Coffee Type", data.drinkType.displayName)
//            )
//            .annotation(position: .trailing, alignment: .leading, content: {
//                Text("\(data.records)")
//                    .opacity(data.drinkType == recordsViewModel.favouriteDrinkType?.drinkType ? 1 : 0.3)
//            })
//            .opacity(data.drinkType == recordsViewModel.favouriteDrinkType?.drinkType ? 1 : 0.3)
//            .foregroundStyle(by: .value("Coffee Type", data.drinkType.displayName))
//        }
//        .chartLegend(.hidden)
//        .frame(maxHeight: 400)
    }
}
