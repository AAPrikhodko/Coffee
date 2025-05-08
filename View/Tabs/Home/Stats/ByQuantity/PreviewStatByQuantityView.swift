//
//  PreviewStatByQuantityView.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//
//
//import SwiftUI
//import Charts
//
//struct PreviewStatByQuantityView: View {
//    var recordsViewModel: RecordsViewModel
//    
//    var body: some View {
//        VStack {
//            if let changedRecordsQuantity = changedRecordsQuantity() {
//                HStack(alignment: .firstTextBaseline) {
//                    Image(systemName: isPositiveChange ? "arrow.up.right" : "arrow.down.right").bold()
//                        .foregroundColor( isPositiveChange ? .green : .red)
//                    
//                    Text("Your coffee consumption ") +
//                    Text(changedRecordsQuantity)
//                        .bold() +
//                    Text(" in the last 90 days.")
//                }
//            }
//            
//            Chart(recordsViewModel.records) { record in
//                BarMark(
//                    x: .value("Week", record.date, unit: .weekOfYear),
//                    y: .value("Records", 1)
//                )
//            }
//            .frame(height: 70)
//            .chartXAxis(.hidden)
//            .chartYAxis(.hidden)
//            
//        }
//    }
//    
//    var percentage: Double {
//        Double(recordsViewModel.totalRecords) / Double(recordsViewModel.lastTotalRecords) - 1
//    }
//    
//    var isPositiveChange: Bool {
//        percentage > 0
//    }
//    
//    func changedRecordsQuantity() -> String? {
//        let percentage = percentage
//        
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .percent
//        
//        
//        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
//            return nil
//        }
//        
//        let changedDescription = percentage < 0 ? "decreased by " : "increased by "
//        
//        return changedDescription + formattedPercentage
//    }
//}
//
//#Preview {
//    PreviewStatByQuantityView(recordsViewModel: RecordsViewModel(user: .dummy))
//        .aspectRatio(1, contentMode: .fit)
//        .padding()
//}

import SwiftUI
import Charts

struct PreviewStatByQuantityView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    private let now = Date()

    private var currentInterval: DateInterval {
        let start = Calendar.current.date(byAdding: .day, value: -10, to: now)!
        return DateInterval(start: start, end: now)
    }

    private var previousInterval: DateInterval {
        let end = Calendar.current.date(byAdding: .day, value: -10, to: now)!
        let start = Calendar.current.date(byAdding: .day, value: -20, to: now)!
        return DateInterval(start: start, end: end)
    }

    private var currentData: [(date: Date, count: Int)] {
        recordsViewModel.records(for: currentInterval)
    }

    private var previousData: [(date: Date, count: Int)] {
        recordsViewModel.records(for: previousInterval)
    }

    private var total: Int {
        currentData.map(\.count).reduce(0, +)
    }

    private var previousTotal: Int {
        previousData.map(\.count).reduce(0, +)
    }

    private var activeDays: Int {
        currentData.filter { $0.count > 0 }.count
    }

    private var deltaPercent: Int {
        guard previousTotal > 0 else { return 100 }
        let change = Double(total - previousTotal) / Double(previousTotal)
        return Int(change * 100)
    }

    private var trendText: String {
        if previousTotal == 0 && total > 0 {
            return "+100%"
        } else if total == previousTotal {
            return "0%"
        } else {
            return deltaPercent > 0 ? "+\(deltaPercent)%" : "\(deltaPercent)%"
        }
    }

    private var trendColor: Color {
        if deltaPercent > 0 {
            return .green
        } else if deltaPercent < 0 {
            return .red
        } else {
            return .gray
        }
    }

    private var statPoints: [StatPoint] {
        currentData.map { StatPoint(date: $0.date, value: Double($0.count)) }
    }
    
    private var trendIconName: String {
        if deltaPercent > 0 {
            return "arrow.up"
        } else if deltaPercent < 0 {
            return "arrow.down"
        } else {
            return "minus"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Last 10 days")
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(spacing: 8) {
                StatTag(label: "\(total) cups", icon: "cup.and.saucer.fill")
                StatTag(label: "\(activeDays) days active", icon: "calendar")
                StatTag(label: trendText, icon: trendIconName, color: trendColor)
            }

            Chart(statPoints) {
                AreaMark(
                    x: .value("Date", $0.date),
                    y: .value("Cups", $0.value)
                )
                .foregroundStyle(.linearGradient(
                    Gradient(colors: [Color.accentColor.opacity(0.3), .clear]),
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
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 40)
        }
        .padding(.vertical, 8)
    }
}


