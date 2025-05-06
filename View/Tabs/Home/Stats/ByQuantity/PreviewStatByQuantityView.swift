//
//  PreviewStatByQuantityView.swift
//  Coffee
//
//  Created by Andrei on 17.02.2025.
//

import SwiftUI
import Charts

struct PreviewStatByQuantityView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        VStack {
            if let changedRecordsQuantity = changedRecordsQuantity() {
                HStack(alignment: .firstTextBaseline) {
                    Image(systemName: isPositiveChange ? "arrow.up.right" : "arrow.down.right").bold()
                        .foregroundColor( isPositiveChange ? .green : .red)
                    
                    Text("Your coffee consumption ") +
                    Text(changedRecordsQuantity)
                        .bold() +
                    Text(" in the last 90 days.")
                }
            }
            
            Chart(recordsViewModel.records) { record in
                BarMark(
                    x: .value("Week", record.date, unit: .weekOfYear),
                    y: .value("Records", 1)
                )
            }
            .frame(height: 70)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            
        }
    }
    
    var percentage: Double {
        Double(recordsViewModel.totalRecords) / Double(recordsViewModel.lastTotalRecords) - 1
    }
    
    var isPositiveChange: Bool {
        percentage > 0
    }
    
    func changedRecordsQuantity() -> String? {
        let percentage = percentage
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        let changedDescription = percentage < 0 ? "decreased by " : "increased by "
        
        return changedDescription + formattedPercentage
    }
}

#Preview {
    PreviewStatByQuantityView(recordsViewModel: RecordsViewModel(user: .dummy))
        .aspectRatio(1, contentMode: .fit)
        .padding()
}
