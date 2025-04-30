//
//  PreviewStatByDrinkTypeView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI
import Charts

struct PreviewStatByDrinkTypeView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            if let favouriteDrinkType = recordsViewModel.favouriteDrinkType,
               let favouriteDrinkTypePercentage  {
                Text("Your favourite cofffe is ") + Text("\(favouriteDrinkType.drinkType.displayName)").bold().foregroundColor(.blue) +
                Text(" with ") +
                Text("\(favouriteDrinkTypePercentage)").bold() +
                Text(" of all cofffe types.")
                
            }
            
            Chart(recordsViewModel.totalRecordsPerDrinkType, id: \.drinkType) { data in
                SectorMark(
                    angle: .value("Sales", data.records),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity(data.drinkType == recordsViewModel.favouriteDrinkType?.drinkType ? 1 : 0.3)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 75)
        }
    }
    
    var favouriteDrinkTypePercentage: String? {
        guard let favouriteDrinkType = recordsViewModel.favouriteDrinkType else { return nil }
        
        let percentage = Double(favouriteDrinkType.records) / Double(recordsViewModel.totalRecords)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        return formattedPercentage
    }
}

#Preview {
    PreviewStatByDrinkTypeView(recordsViewModel: .preview)
        .padding()
}
