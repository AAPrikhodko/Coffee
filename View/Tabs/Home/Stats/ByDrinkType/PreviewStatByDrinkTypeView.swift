//
//  PreviewStatByDrinkTypeView.swift
//  Coffee
//
//  Created by Andrei on 19.02.2025.
//

//import SwiftUI
//import Charts
//
//struct PreviewStatByDrinkTypeView: View {
//    var recordsViewModel: RecordsViewModel
//    
//    var body: some View {
//        HStack(spacing: 30) {
//            if let favouriteDrinkType = recordsViewModel.favouriteDrinkType,
//               let favouriteDrinkTypePercentage  {
//                Text("Your favourite cofffe is ") + Text("\(favouriteDrinkType.drinkType.displayName)").bold().foregroundColor(.blue) +
//                Text(" with ") +
//                Text("\(favouriteDrinkTypePercentage)").bold() +
//                Text(" of all cofffe types.")
//                
//            }
//            
//            Chart(recordsViewModel.totalRecordsPerDrinkType, id: \.drinkType) { data in
//                SectorMark(
//                    angle: .value("Sales", data.records),
//                    innerRadius: .ratio(0.618),
//                    angularInset: 1.5
//                )
//                .cornerRadius(5.0)
//                .opacity(data.drinkType == recordsViewModel.favouriteDrinkType?.drinkType ? 1 : 0.3)
//            }
//            .aspectRatio(1, contentMode: .fit)
//            .frame(height: 75)
//        }
//    }
    
//    var favouriteDrinkTypePercentage: String? {
//        guard let favouriteDrinkType = recordsViewModel.favouriteDrinkType else { return nil }
//        
//        let percentage = Double(favouriteDrinkType.records) / Double(recordsViewModel.totalRecords)
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = .percent
//        
//        guard let formattedPercentage = numberFormatter.string(from: NSNumber(value: percentage)) else {
//            return nil
//        }
//        
//        return formattedPercentage
//    }
//}

import SwiftUI
import Charts

struct PreviewStatByDrinkTypeView: View {
    @Environment(RecordsViewModel.self) var recordsViewModel

    private var topStats: [DrinkTypeStats] {
        Array(recordsViewModel.drinkStats.prefix(5))
    }

    private var favourite: DrinkTypeStats? {
        print("totalRecordsPerDrinkType:", recordsViewModel.totalRecordsPerDrinkType)
        print("drinkStats:", recordsViewModel.drinkStats)
        return topStats.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // 🔹 Верхняя строка: слева — тэг, справа — заголовок
            HStack {
                
                if let favourite {
                    StatTag(
                        label: "\(favourite.type.displayName) – \(favourite.count) cups",
                        icon: "cup.and.saucer.fill"
                    )
                }
                Spacer()
                Text("Favourite coffee")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // 🔹 Основной блок: пояснение + диаграмма в HStack
            if let favourite {
                HStack(alignment: .center, spacing: 12) {
                    // Текст-пояснение
                    (
                        Text("Based on last 90 days, your favourite coffee is ")
                        + Text(favourite.type.displayName).bold()
                    )
                    .font(.footnote) // крупнее caption
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                    Spacer()
                
                    // Круговая диаграмма
                    Chart(topStats) { stat in
                        SectorMark(
                            angle: .value("Count", stat.count),
                            innerRadius: .ratio(0.5),
                            angularInset: 1
                        )
                        .foregroundStyle(by: .value("Drink", stat.type.displayName))
                    }
                    .chartLegend(.hidden)
                    .frame(width: 100, height: 100)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

