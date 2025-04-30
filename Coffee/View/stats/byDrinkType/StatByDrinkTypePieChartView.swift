//
//  StatByDrinkTypePieChartView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI
import Charts

struct StatByDrinkTypePieChartView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
     
            Chart(recordsViewModel.totalRecordsPerDrinkType, id: \.drinkType) { data in
                SectorMark(
                    angle: .value("Records", data.records),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .opacity(data.drinkType == recordsViewModel.favouriteDrinkType?.drinkType ? 1 : 0.3)
                .foregroundStyle(by: .value("Coffee Type", data.drinkType.displayName))
            }
            .aspectRatio(1, contentMode: .fit)
            .chartLegend(position: .bottom, spacing: 20)
            .chartBackground { chartProxy in
                GeometryReader(content: { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    let visiibleSize = min(frame.width, frame.height)
                    
                    if let favouriteDrinkType = recordsViewModel.favouriteDrinkType {
                        VStack {
                            Text("Favourite coffee")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text(favouriteDrinkType.drinkType.displayName)
                                .font(.title.bold())
                                .foregroundStyle(.primary)
                            Text(favouriteDrinkType.records.formatted() + " cups")
                                
                        }
                        .frame(
                            maxWidth: visiibleSize * 0.618,
                            maxHeight: visiibleSize * 0.618
                        )
                        .position(x: frame.midX, y: frame.midY)
                    }
                        
                })
            }

    }
}

#Preview {
    StatByDrinkTypePieChartView(recordsViewModel: .preview)
        .padding()
}
