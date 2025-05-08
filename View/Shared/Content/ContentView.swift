//
//  ContentView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(AuthViewModel.self) private var authViewModel
    @State private var recordsViewModel: RecordsViewModel?
    
    var body: some View {
        Group {
            if let recordsViewModel {
                TabView {
                    Tab("Home", systemImage: "house") {
                        HomeTabView().environment(recordsViewModel)
                    }
                    
                    Tab("Calendar", systemImage: "calendar") {
                        CalendarTabView().environment(recordsViewModel)
                    }
                    
                    Tab("My Map", systemImage: "map") {
                        MyMapTabView()
                    }
                    
                    Tab("Settings", systemImage: "gearshape") {
                        SettingsTabView()
                    }
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            updateRecordsViewModelIfNeeded()
        }
        .onChange(of: authViewModel.currentUser) { oldUser, newUser in
            updateRecordsViewModelIfNeeded()
        }
    }
    
    private func updateRecordsViewModelIfNeeded() {
        guard let user = authViewModel.currentUser else {
            recordsViewModel = nil
            return
        }

        if let existingVM = recordsViewModel {
            if existingVM.userId != user.id {
                existingVM.reset(for: user.id)
            }
        } else {
            recordsViewModel = RecordsViewModel(user: user)
        }
    }
}

#Preview {
    ContentView()
}
