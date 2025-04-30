//
//  StatByQuantityView.swift
//  Coffee
//
//  Created by Andrei on 18.02.2025.
//

import SwiftUI

struct StatByQuantityView: View {
    enum TimeInterval: String, CaseIterable, Identifiable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        
        var id: Self {return self}
    }
    
    var recordsViewModel: RecordsViewModel
    @State private var selectedTimeInterval: TimeInterval = .week

    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $selectedTimeInterval.animation()) {
                ForEach(TimeInterval.allCases) { interval in
                    Text(interval.rawValue)
                }
            } label: {
                Text("Time interval")
            }
            .pickerStyle(.segmented)

            
             Group {
                 Text("You drank ") +
                 Text("\(recordsViewModel.totalRecords) cups of cofee").bold().foregroundColor(Color.accentColor) +
                 Text(" in the last 90 days.")
             }.padding(.vertical)
             
            
            Group {
                switch selectedTimeInterval {
                case .day:
                    DailyRecordsChartView(recordsData: recordsViewModel.records)
                case .week:
                    WeeklyRecordsChartView(recordsViewModel: recordsViewModel)
                case .month:
                    MounthlyRecordsChartsView(recordsData: recordsViewModel.records)
                }
            }
            .aspectRatio(0.8, contentMode: .fit)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    StatByQuantityView(recordsViewModel: .preview)
}
