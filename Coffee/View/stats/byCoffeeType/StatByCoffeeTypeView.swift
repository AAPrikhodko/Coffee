//
//  StatByCoffeeTypeView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI

struct StatByCoffeeTypeView: View {
    
    enum ChartStyle: CaseIterable, Identifiable {
        case pie
        case bar
        
        var id: Self { self }
        
        var displayName: String {
            switch self {
            case .pie:
                return "Pie Chart"
            case .bar:
                return "Bar Chart"
            }
        }
    }
    
    var recordsViewModel: RecordsViewModel
    @State private var selectedChartStyle: ChartStyle = .pie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Picker("Chart Type", selection: $selectedChartStyle.animation()) {
                ForEach(ChartStyle.allCases) {
                    Text($0.displayName)
                }
            }
            .pickerStyle(.segmented)
            
            switch selectedChartStyle {
            case .pie:
                StatByCoffeeTypePieChartView(recordsViewModel: recordsViewModel)
            case .bar:
                StatByCoffeeTypeBarChartView(recordsViewModel: recordsViewModel)
            }
        }
        .padding()
        
        Spacer()
    }
}

#Preview {
    StatByCoffeeTypeView(recordsViewModel: .preview)
        .padding()
}
