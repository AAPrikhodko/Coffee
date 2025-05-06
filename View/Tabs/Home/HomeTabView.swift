//
//  HomeTabView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @Environment(RecordsViewModel.self) private var recordsViewModel
    
    @State private var showAddDrinkSheet: Bool = false
    
    var body: some View {
        NavigationStack() {
            NavigationLink {
                ProfileView()
            } label: {
                ProfilPreviewView()
                    .padding()
            }
            
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
                        StatByDrinkTypeView(recordsViewModel: recordsViewModel)
                    } label: {
                        PreviewStatByDrinkTypeView(recordsViewModel: recordsViewModel)
                    }
                }
                
                Section {
                    NavigationLink {
                        StatByExpensesView(recordsViewModel: recordsViewModel)
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
                        authViewModel: authViewModel,
                        recordsViewModel: recordsViewModel
                    )
                }
        }
    }
}

#Preview {
    HomeTabView()
}
