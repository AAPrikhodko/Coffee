//
//  WeeklyRecordsChartView.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import SwiftUI
import Charts

struct WeeklyRecordsChartView: View {
    var recordsViewModel: RecordsViewModel
    @State private var rawSelectedDate: Date? = nil
    
    @Environment(\.calendar) var calendar
    
//    var selectedDateValue: (day: Date, records: Int)? {
//        if let rawSelectedDate {
//            
//            return recordsViewModel.recordsByWeek.first(where: {
//                let startOfWeek = $0.day
//                let endOfWeek = endOfWeek(for: startOfWeek) ?? Date()
//                return (startOfWeek ... endOfWeek).contains(rawSelectedDate)
//            })
//        }
//        
//        return nil
//    }
    
    var body: some View {
        Text("Hello from settings tab!")
//        Chart(recordsViewModel.recordsByWeek, id: \.day) { record in
//            BarMark(
//                x: .value("Week", record.day, unit: .weekOfYear),
//                y: .value("Records", record.records)
//            )
//            .opacity(selectedDateValue == nil || record.day == selectedDateValue?.day ? 1 : 0.5)
//            
//            if let rawSelectedDate {
//                   RuleMark(x: .value("Selected",
//                                      rawSelectedDate,
//                                      unit: .day))
//                   .foregroundStyle(Color.gray.opacity(0.3))
//                   .offset(yStart: -10)
//                   .zIndex(-1)
//                   .annotation(
//                       position: .top,
//                       spacing: 0,
//                       overflowResolution: .init(
//                           x: .fit(to: .chart),
//                           y: .disabled
//                       )
//                   ) {
//                       selectionPopover
//                   }
//               }
//        }
//        .chartXSelection(value: $rawSelectedDate)
    }
    
    func endOfWeek(for startOfWeek: Date) -> Date? {
         calendar.date(byAdding: .day, value: 6, to: startOfWeek)
    }
    
    func beginingOfWeek(for date: Date) -> Date? {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))
    }
    
//    @ViewBuilder
//    var selectionPopover: some View {
//        if let rawSelectedDate,
//            let selectedDateValue {
//            VStack {
//                Text(rawSelectedDate.formatted(.dateTime.month().day()))
//                
//                Text(selectedDateValue.day.formatted(.dateTime.month().day()))
//                Text("\(selectedDateValue.records) cups")
//                    .bold()
//                    .foregroundStyle(.blue)
//            }
//            .padding(6)
//            .background {
//                RoundedRectangle(cornerRadius: 4)
//                    .fill(Color.white)
//                    .shadow(color: .blue, radius: 2)
//            }
//        }
//    }
}
