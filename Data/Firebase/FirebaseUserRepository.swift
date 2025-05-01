//
//  FirebaseUserRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let collection = "users"

    func fetchCurrentUser() async throws -> User {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])
        }

        let docRef = db.collection(collection).document(uid)
        let document = try await docRef.getDocument()
        let user = try document.data(as: User.self)

        return user
    }

    func createUser(_ user: User) async throws {
        try db.collection(collection).document(user.id.uuidString).setData(from: user)
    }

    func updateUser(_ user: User) async throws {
        try db.collection(collection).document(user.id.uuidString).setData(from: user, merge: true)
    }
}

