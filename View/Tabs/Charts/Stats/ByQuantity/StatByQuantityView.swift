//
//  StatByQuantityView.swift
//  Coffee
//
//  Created by Andrei on 18.02.2025.
//

//import SwiftUI
//
//struct StatByQuantityView: View {
//    enum TimeInterval: String, CaseIterable, Identifiable {
//        case day = "Day"
//        case week = "Week"
//        case month = "Month"
//        
//        var id: Self {return self}
//    }
//    
//    var recordsViewModel: RecordsViewModel
//    @State private var selectedTimeInterval: TimeInterval = .week
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Picker(selection: $selectedTimeInterval.animation()) {
//                ForEach(TimeInterval.allCases) { interval in
//                    Text(interval.rawValue)
//                }
//            } label: {
//                Text("Time interval")
//            }
//            .pickerStyle(.segmented)
//
//            
//             Group {
//                 Text("You drank ") +
//                 Text("\(recordsViewModel.totalRecords) cups of cofee").bold().foregroundColor(Color.accentColor) +
//                 Text(" in the last 90 days.")
//             }.padding(.vertical)
//             
//            
//            Group {
//                switch selectedTimeInterval {
//                case .day:
//                    DailyRecordsChartView(recordsData: recordsViewModel.records)
//                case .week:
//                    WeeklyRecordsChartView(recordsViewModel: recordsViewModel)
//                case .month:
//                    MounthlyRecordsChartsView(recordsData: recordsViewModel.records)
//                }
//            }
//            .aspectRatio(0.8, contentMode: .fit)
//            
//            Spacer()
//        }
//        .padding()
//    }
//}

import SwiftUI
import Charts

struct StatByQuantityView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    @State private var selectedDays: Int = 30

    private var interval: DateInterval {
        let now = Date()
        let start = Calendar.current.date(byAdding: .day, value: -selectedDays, to: now)!
        return DateInterval(start: start, end: now)
    }

    var data: [(date: Date, count: Int)] {
        recordsViewModel.records(for: interval)
    }

    var statPoints: [StatPoint] {
        data.map { StatPoint(date: $0.date, value: Double($0.count)) }
    }

    var body: some View {
        VStack {
            Picker("Range", selection: $selectedDays) {
                Text("10 Days").tag(10)
                Text("30 Days").tag(30)
                Text("90 Days").tag(90)
            }
            .pickerStyle(.segmented)
            .padding()

            Chart(statPoints) {
                AreaMark(
                    x: .value("Date", $0.date),
                    y: .value("Cups", $0.value)
                )
                .foregroundStyle(.linearGradient(
                    Gradient(colors: [.accentColor.opacity(0.3), .clear]),
                    startPoint: .top,
                    endPoint: .bottom
                ))

                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Cups", $0.value)
                )
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Date", $0.date),
                    y: .value("Cups", $0.value)
                )
            }
            .padding()
        }
        .navigationTitle("Consumption")
    }
}

