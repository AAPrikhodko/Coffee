//
//  AuthView.swift
//  Coffee
//
//  Created by Andrei on 01.05.2025.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @State private var isLoginMode = true

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Picker("Auth Mode", selection: $isLoginMode) {
                    Text("Login").tag(true)
                    Text("Register").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                TextField("Email", text: $viewModel.email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button {
                    Task {
                        if isLoginMode {
                            await viewModel.login()
                        } else {
                            await viewModel.register()
                        }
                    }
                } label: {
                    if viewModel.isLoading {
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
                .disabled(viewModel.email.isEmpty || viewModel.password.isEmpty)

                Spacer()
            }
            .padding()
            .navigationTitle(isLoginMode ? "Login" : "Register")
            .onAppear {
                viewModel.checkAuthStatus()
            }
        }
        .fullScreenCover(isPresented: $viewModel.isLoggedIn) {
            ContentView() // ← Здесь покажем основной интерфейс
        }
    }
}
