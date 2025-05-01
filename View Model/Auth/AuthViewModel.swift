//
//  AuthViewModel.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

    private let authManager = AuthManager.shared

    // MARK: - Регистрация
    func register() async {
        isLoading = true
        errorMessage = nil

        do {
            let uid = try await authManager.register(email: email, password: password)
            print("✅ Зарегистрирован: \(uid)")
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Вход
    func login() async {
        isLoading = true
        errorMessage = nil

        do {
            let uid = try await authManager.login(email: email, password: password)
            print("✅ Вошел: \(uid)")
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    // MARK: - Выход
    func logout() {
        do {
            try authManager.logout()
            isLoggedIn = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Проверка при старте
    func checkAuthStatus() {
        isLoggedIn = authManager.isUserLoggedIn()
    }
}
