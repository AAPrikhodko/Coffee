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
    @State private var authViewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView().environment(authViewModel)
        }
    }
}
