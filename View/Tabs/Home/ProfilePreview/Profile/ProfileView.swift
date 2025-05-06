//
//  ProfileView.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import SwiftUI

struct ProfileView: View {
    @Environment(AuthViewModel.self) var authViewModel
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var country = ""

    var body: some View {
        Form {
            Section(header: Text("Профиль")) {
                TextField("Имя", text: $firstName)
                TextField("Фамилия", text: $lastName)
                TextField("Страна", text: $country)
            }

            Button("Сохранить") {
                print("🔘 Кнопка нажата")

                guard var user = authViewModel.currentUser else {
                    print("❌ currentUser не найден")
                    return
                }

                user.firstName = firstName
                user.lastName = lastName
                user.country = country

                Task {
                    do {
                        print("📤 Отправка обновленного пользователя...")
                        try await FirebaseUserRepository().updateUser(user)
                        authViewModel.currentUser = user
                        print("✅ Пользователь обновлён")
                    } catch {
                        print("❌ Ошибка при обновлении: \(error.localizedDescription)")
                    }
                }
            }
        }
        .navigationTitle("Профиль")
        .onAppear {
            if let user = authViewModel.currentUser {
                firstName = user.firstName
                lastName = user.lastName
                country = user.country
            }
        }
    }
}
