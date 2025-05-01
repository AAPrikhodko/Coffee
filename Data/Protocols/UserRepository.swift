//
//  UserRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation

protocol UserRepository {
    func fetchCurrentUser() async throws -> User
    func createUser(_ user: User) async throws
    func updateUser(_ user: User) async throws
}
