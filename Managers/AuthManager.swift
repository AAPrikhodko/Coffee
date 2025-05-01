//
//  AuthManager.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import Foundation
import FirebaseAuth

final class AuthManager {
    static let shared = AuthManager()
    private let auth = Auth.auth()

    private init() {}

    // MARK: - Регистрация нового пользователя
    func register(email: String, password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user.uid
    }

    // MARK: - Вход пользователя
    func login(email: String, password: String) async throws -> String {
        let result = try await auth.signIn(withEmail: email, password: password)
        return result.user.uid
    }

    // MARK: - Выход из аккаунта
    func logout() throws {
        try auth.signOut()
    }

    // MARK: - Получение ID текущего пользователя
    func getCurrentUserId() -> String? {
        return auth.currentUser?.uid
    }

    // MARK: - Проверка авторизации
    func isUserLoggedIn() -> Bool {
        return auth.currentUser != nil
    }
}
