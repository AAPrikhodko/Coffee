//
//  HomeTabView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct HomeTabView: View {
    @State private var showAddDrinkSheet: Bool = false
    
    var body: some View {
        UserInfo()
            .padding()
        
        PersonalStat()
            .padding(.bottom)
        
        GlobalStat()
            .padding(.bottom)
        
        AddDrinkButton(showAddDrinkSheet: $showAddDrinkSheet)
            .fullScreenCover(isPresented: $showAddDrinkSheet) {
                AddRecordView(isSheetShown: $showAddDrinkSheet)
            }
            
        
        Spacer()
    }
}

#Preview {
    HomeTabView()
}
