//
//  ChartsTabView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct ChartsTabView: View {
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
                        StatByQuantityView()
                    } label: {
                        PreviewStatByQuantityView()
                    }
                }
                
                Section {
                    NavigationLink {
                        StatByDrinkTypeView()
                    } label: {
                        PreviewStatByDrinkTypeView()
                    }
                }
                
                Section {
                    NavigationLink {
                        StatByExpensesView()
                    } label: {
                        PreviewStatByExpensesView()
                    }
                }
            }
            
            
            AddDrinkButton(showSheet: $showAddDrinkSheet)
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
    ChartsTabView()
}
