//
//  StatByDrinkTypeView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

//import SwiftUI
//
//struct StatByDrinkTypeView: View {
//    
//    enum ChartStyle: CaseIterable, Identifiable {
//        case pie
//        case bar
//        
//        var id: Self { self }
//        
//        var displayName: String {
//            switch self {
//            case .pie:
//                return "Pie Chart"
//            case .bar:
//                return "Bar Chart"
//            }
//        }
//    }
//    
//    var recordsViewModel: RecordsViewModel
//    @State private var selectedChartStyle: ChartStyle = .pie
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 20) {
//            Picker("Chart Type", selection: $selectedChartStyle.animation()) {
//                ForEach(ChartStyle.allCases) {
//                    Text($0.displayName)
//                }
//            }
//            .pickerStyle(.segmented)
//            
//            switch selectedChartStyle {
//            case .pie:
//                StatByDrinkTypePieChartView(recordsViewModel: recordsViewModel)
//            case .bar:
//                StatByDrinkTypeBarChartView(recordsViewModel: recordsViewModel)
//            }
//        }
//        .padding()
//        
//        Spacer()
//    }
//}

import SwiftUI
import Charts

struct StatByDrinkTypeView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    private var stats: [DrinkTypeStats] {
        recordsViewModel.drinkStats
    }

    private var total: Int {
        stats.map(\.count).reduce(0, +)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Drink types")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("Distribution of coffee types based on your records.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // 🔹 Chart + Legend
                HStack(alignment: .top, spacing: 24) {
                    // Pie Chart
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
                    
//                    Chart(stats) { stat in
//                        SectorMark(
//                            angle: .value("Count", stat.count),
//                            innerRadius: .ratio(0.5),
//                            angularInset: 2
//                        )
//                        .foregroundStyle(by: .value("Type", stat.type.displayName))
//                        .annotation(position: .overlay, alignment: .center) {
//                            if let max = stats.max(by: { $0.count < $1.count }) {
//                                Text(max.type.displayName)
//                                    .font(.footnote)
//                                    .foregroundColor(.primary)
//                            }
//                        }
//                    }
//                    .frame(width: 200, height: 200)
//                    .chartLegend(.hidden)

                    // Legend
//                    VStack(alignment: .leading, spacing: 12) {
//                        ForEach(stats.prefix(10)) { stat in
//                            HStack {
//                                Circle()
//                                    .fill(ChartColor.forDrink(stat.type))
//                                    .frame(width: 12, height: 12)
//
//                                Text(stat.type.displayName)
//                                    .font(.subheadline)
//
//                                Spacer()
//
//                                Text("\(stat.count) cups")
//                                    .font(.subheadline)
//                                    .foregroundColor(.secondary)
//                            }
//                        }
//                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("By Drink Type")
        .navigationBarTitleDisplayMode(.inline)
    }
}
