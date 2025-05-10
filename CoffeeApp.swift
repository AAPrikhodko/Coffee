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
    @State private var recordsViewModel: RecordsViewModel

    init() {
        FirebaseApp.configure()

        // Создаём временный user, чтобы инициализировать модель
        let dummyUser = User(
            id: UUID(),
            firstName: "",
            lastName: "",
            avatarURL: nil,
            country: "",
            registrationDate: Date(),
            favoriteDrink: nil,
            achievements: []
        )
        _recordsViewModel = State(initialValue: RecordsViewModel(user: dummyUser))
    }

    var body: some Scene {
        WindowGroup {
            AuthView()
                .environment(authViewModel)
                .environment(recordsViewModel)
        }
    }
}

