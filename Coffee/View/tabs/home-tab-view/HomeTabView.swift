//
//  HomeTabView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct HomeTabView: View {
    @Binding var recordsViewModel: RecordsViewModel
    
    @State private var showAddDrinkSheet: Bool = false
    
    var body: some View {
        NavigationStack() {
            UserInfo()
                .padding()
            
            List {
                Section {
                    NavigationLink {
                        StatByQuantityView(recordsViewModel: recordsViewModel)
                    } label: {
                        PreviewStatByQuantityView(recordsViewModel: recordsViewModel)
                    }
                }
                
                Section {
                    NavigationLink {
                        StatByCoffeeTypeView(recordsViewModel: recordsViewModel)
                    } label: {
                        PreviewStatByCoffeeTypeView(recordsViewModel: recordsViewModel)
                    }
                }
                
                Section {
                    NavigationLink {
                        StatByCoffeeTypeView(recordsViewModel: recordsViewModel)
                    } label: {
                        PreviewStatByExpensesView(recordsViewModel: recordsViewModel)
                    }
                }
            }
            
            
            AddDrinkButton(showAddDrinkSheet: $showAddDrinkSheet)
                .padding(.bottom, 30)
                .fullScreenCover(isPresented: $showAddDrinkSheet) {
                    AddRecordView(
                        isSheetShown: $showAddDrinkSheet,
                        recordsViewModel: $recordsViewModel
                    )
                }
        }
    }
}

#Preview {
    HomeTabView(
        recordsViewModel: .constant(RecordsViewModel())
    )
}
