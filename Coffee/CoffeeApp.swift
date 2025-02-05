//
//  CoffeeApp.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

@main
struct CoffeeApp: App {
    @StateObject var locationSearchViewModel = LocationSearchViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationSearchViewModel)
        }
    }
}
