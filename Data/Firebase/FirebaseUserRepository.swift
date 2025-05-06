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
    private lazy var db = Firestore.firestore()
    private lazy var auth = Auth.auth()
    private let collection = "users"
    
    private func getFirebaseUID() throws -> String {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])
        }
        return uid
    }

    func fetchCurrentUser() async throws -> User {
        let uid = try getFirebaseUID()

        let docRef = db.collection(collection).document(uid)
        let document = try await docRef.getDocument()
        let user = try document.data(as: User.self)

        return user
    }

    func createUser(_ user: User) async throws {
        let uid = try getFirebaseUID()
        try db.collection(collection).document(uid).setData(from: user)
    }

//    func updateUser(_ user: User) async throws {
//        try db.collection(collection).document(user.id.uuidString).setData(from: user, merge: true)
//    }
    func updateUser(_ user: User) async throws {
        let uid = try getFirebaseUID()
        try db.collection("users")
            .document(uid)
            .setData(from: user, merge: true)
    }
}

