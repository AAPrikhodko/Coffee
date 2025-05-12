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

    @State private var isSaving = false
    @State private var showLogoutConfirmation = false
    @State private var showSaveSuccess = false
    @State private var saveErrorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Profile")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                        TextField("Country", text: $country)
                    }
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        saveProfile()
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(hasChanges ? Color.accentColor : Color.gray.opacity(0.4))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(!hasChanges || isSaving)

                    Button(role: .destructive) {
                        showLogoutConfirmation = true
                    } label: {
                        Text("Log Out")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .navigationTitle("Edit Profile")
            .onAppear {
                if let user = authViewModel.currentUser {
                    firstName = user.firstName
                    lastName = user.lastName
                    country = user.country
                }
            }
            .alert("Error", isPresented: .constant(saveErrorMessage != nil)) {
                Button("OK", role: .cancel) {
                    saveErrorMessage = nil
                }
            } message: {
                Text(saveErrorMessage ?? "")
            }
            .alert("Saved", isPresented: $showSaveSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Profile has been updated")
            }
            .alert("Are you sure you want to log out?", isPresented: $showLogoutConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    authViewModel.logout()
                }
            }
        }
    }

    private var hasChanges: Bool {
        guard let user = authViewModel.currentUser else { return false }
        return user.firstName != firstName || user.lastName != lastName || user.country != country
    }

    private func saveProfile() {
        guard var user = authViewModel.currentUser else {
            saveErrorMessage = "User not found"
            return
        }

        user.firstName = firstName
        user.lastName = lastName
        user.country = country

        isSaving = true
        Task {
            do {
                try await FirebaseUserRepository().updateUser(user)
                authViewModel.currentUser = user
                showSaveSuccess = true
            } catch {
                saveErrorMessage = "Failed to save profile: \(error.localizedDescription)"
            }
            isSaving = false
        }
    }
}
