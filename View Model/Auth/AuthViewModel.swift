//
//  AuthViewModel.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import Foundation
import SwiftUI

@Observable
class AuthViewModel {
    // MARK: - Данные пользователя
    var currentUser: User?

    // MARK: - Вводимые данные
    var email: String = ""
    var password: String = ""

    // MARK: - Состояние
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    var errorMessage: String?

    // MARK: - Зависимости
    private let authManager = AuthManager.shared
    private let userRepository: UserRepository = FirebaseUserRepository()

    // MARK: - Регистрация
    func register() async {
        isLoading = true
        errorMessage = nil

        do {
            let uid = try await authManager.register(email: email, password: password)
            print("✅ Зарегистрирован: \(uid)")

            let newUser = User(
                id: UUID(),
                firstName: "",
                lastName: "",
                avatarURL: nil,
                country: "",
                registrationDate: Date(),
                favoriteDrink: nil,
                achievements: [.newcomer]
            )

            try await userRepository.createUser(newUser)
            currentUser = newUser
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

            let user = try await userRepository.fetchCurrentUser()
            currentUser = user
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
            currentUser = nil
            isLoggedIn = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Проверка при запуске
    func checkAuthStatus() {
        isLoggedIn = authManager.isUserLoggedIn()

        Task {
            if isLoggedIn {
                do {
                    currentUser = try await userRepository.fetchCurrentUser()
                } catch {
                    errorMessage = "Не удалось загрузить пользователя: \(error.localizedDescription)"
                    isLoggedIn = false
                }
            }
        }
    }
}
