//
//  DonutChartView.swift
//  Coffee
//
//  Created by Andrei on 28.05.2025.
//

import Charts
import SwiftUI

struct DonutChartView: View {
    let items: [GroupedItem]
    let totalValue: Double
    let measure: ChartsTabView2.Measure

    @State private var selectedID: String?

    var body: some View {
        VStack {
            Chart(items, id: \.id) { item in
                SectorMark(
                    angle: .value("Value", item.value),
                    innerRadius: .ratio(0.6),
                    outerRadius: .ratio(selectedID == item.id ? 1.05 : 1.0),
                    angularInset: 1.5
                )
                .foregroundStyle(item.color)
                .opacity(selectedID == nil || selectedID == item.id ? 1.0 : 0.4)
                .cornerRadius(4)
                .annotation(position: .overlay, alignment: .center) {
                    if selectedID == item.id || selectedID == nil {
                        VStack(spacing: 4) {
                            Text(selectedID == nil ? "Total" : item.label)
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text(formattedValue(for: selectedID == nil ? totalValue : item.value))
                                .font(.title2).bold()
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .frame(height: 220)
            .chartAngleSelection(value: $selectedID)
            .chartBackground { proxy in
                GeometryReader { geo in
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedID = nil
                        }
                }
            }
        }
        .padding(.vertical)
    }

    private func formattedValue(for value: Double) -> String {
        switch measure {
        case .spent:
            return String(format: "%.2f €", value)
        case .cups:
            return "\(Int(value)) Cups"
        case .liters:
            return String(format: "%.1f L", value)
        }
    }
}
