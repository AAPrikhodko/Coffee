//
//  StatByExpensesView.swift
//  Coffee
//
//  Created by Andrei on 26.02.2025.
//

import SwiftUI

struct StatByExpensesView: View {
    var recordsViewModel: RecordsViewModel
    
    var body: some View {

        ScrollView {
//            ForEach(recordsViewModel.records) {record in
//                VStack(alignment: .leading) {
//                    Text("date: \(record.date)")
//                    Text("type: \(record.type)")
//                    Text("price: \(record.price)")
//                }
//                .padding()
//            }
            
            ForEach(recordsViewModel.recordsByDay, id: \.day) {recordByDay in
                VStack {
                    Text("Day: \(recordByDay.day)")
                    Text("Records: \(recordByDay.records)")
                }
                .padding()
            }
        }
    }
}
