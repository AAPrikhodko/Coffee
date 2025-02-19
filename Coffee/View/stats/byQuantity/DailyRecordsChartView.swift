//
//  DailyRecordsChartView.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import SwiftUI
import Charts

struct DailyRecordsChartView: View {
    let recordsData: [Record]
    
    init(recordsData: [Record]) {
        self.recordsData = recordsData
        
        guard let lastDate = recordsData.last?.date else { return }
        let beginingOfInterval = lastDate.addingTimeInterval(-1 * 3600 * 24 * 30)
        
        self._scrollPosition = State(initialValue: beginingOfInterval.timeIntervalSinceReferenceDate)

    }
    
    let numberOfDisplayDays = 30
    
    @State var scrollPosition: TimeInterval = TimeInterval()
    
    var scrollPositionStart: Date {
        Date(timeIntervalSinceReferenceDate: scrollPosition)
    }
    
    var scrollPositionEnd: Date {
        scrollPositionStart.addingTimeInterval(3600 * 24 * 30)
    }
    
    var scrollPositionString: String {
        scrollPositionStart.formatted(.dateTime.month().day())
    }
    
    var scrollPositionEndString: String {
        scrollPositionEnd.formatted(.dateTime.month().day().year())
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(scrollPositionString) – \(scrollPositionEndString)")
                .font(.callout)
                .foregroundStyle(.secondary)
            
            Chart(recordsData) { record in
                BarMark(
                    x: .value("Day", record.date, unit: .day),
                    y: .value("Records", 1)
                )
            }
            .chartScrollableAxes(.horizontal)
            .chartXVisibleDomain(length: 3600 * 24 * numberOfDisplayDays)
            .chartScrollPosition(x: $scrollPosition)
        }

    }
}

#Preview {
    DailyRecordsChartView(recordsData: Record.threeMonthsExamples())
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
