//
//  CoffeeApp.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI
import Firebase

@main
struct CoffeeApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
