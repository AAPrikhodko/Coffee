//
//  ContentView.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house") {
                HomeTabView()
            }
            
            Tab("My Map", systemImage: "map") {
                MyMapTabView()
            }
            
            Tab("Settings", systemImage: "gearshape") {
                SettingsTabView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationSearchViewModel())
}
