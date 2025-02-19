//
//  PreviewStatByCoffeeTypeView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

import SwiftUI
import Charts

struct PreviewStatByCoffeeTypeView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {
        HStack(spacing: 30) {
            if let favouriteCoffeeType = recordsViewModel.favouriteCoffeeType,
               let favouriteCoffeeTypePercentage  {
                Text("Your favourite cofffe is ") + Text("\(favouriteCoffeeType.coffeeType.title)").bold().foregroundColor(.blue) +
                Text(" with ") +
                Text("\(favouriteCoffeeTypePercentage)").bold() +
                Text(" of all cofffe types.")
                
            }
            
            Chart(recordsViewModel.totalRecordsPerCoffeeType, id: \.coffeeType) { data in
                SectorMark(
                    angle: .value("Sales", data.records),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5.0)
                .opacity(data.coffeeType == recordsViewModel.favouriteCoffeeType?.coffeeType ? 1 : 0.3)
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(height: 75)
        }
    }
    
    var favouriteCoffeeTypePercentage: String? {
        guard let favouriteCoffeeType = recordsViewModel.favouriteCoffeeType else { return nil }
        
        let percentage = Double(favouriteCoffeeType.records) / Double(recordsViewModel.totalRecords)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        
        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
            return nil
        }
        
        return formattedPercentage
    }
}

#Preview {
    PreviewStatByCoffeeTypeView(recordsViewModel: .preview)
        .padding()
}
