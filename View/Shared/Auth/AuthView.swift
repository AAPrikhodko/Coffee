//
//  AuthView.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import SwiftUI

struct AuthView: View {
    @Environment(AuthViewModel.self) var authViewModel
    
    @State private var isLoginMode = true
    
    var emailBinding: Binding<String> {
        Binding {
            authViewModel.email
        } set: {
            authViewModel.email = $0
        }
    }
    
    var passwordBinding: Binding<String> {
        Binding {
            authViewModel.password
        } set: {
            authViewModel.password = $0
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Auth Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Email", text: emailBinding)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Password", text: passwordBinding)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button {
                    Task {
                        if isLoginMode {
                            await authViewModel.login()
                        } else {
                            await authViewModel.register()
                        }
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                    } else {
                        Text(isLoginMode ? "Login" : "Register")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .disabled(authViewModel.email.isEmpty || authViewModel.password.isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle(isLoginMode ? "Login" : "Register")
            .onAppear {
                authViewModel.checkAuthStatus()
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { authViewModel.isLoggedIn },
            set: { _ in }
        )) {
            ContentView()
        }
    }
}
