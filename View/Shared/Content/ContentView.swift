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
                    Tab("Charts", systemImage: "chart.bar") {
                        ChartsTabView()
                    }

                    Tab("Calendar", systemImage: "calendar") {
                        CalendarTabView()
                    }

                    Tab("Geo Map", systemImage: "map") {
                        GeoMapTabView()
                    }

                    Tab("Settings", systemImage: "gearshape") {
                        SettingsTabView()
                    }
                }
                .environment(recordsViewModel)
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            updateRecordsViewModelIfNeeded()
        }
        .onChange(of: authViewModel.currentUser) { _, _ in
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
