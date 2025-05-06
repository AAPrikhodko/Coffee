//
//  FirebaseRecordRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class FirebaseRecordRepository: RecordRepository {
    private lazy var db = Firestore.firestore()
    private lazy var auth = Auth.auth()
    private let collection = "records"

    private func getFirebaseUID() throws -> String {
        guard let uid = auth.currentUser?.uid else {
            throw NSError(domain: "auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"])
        }
        return uid
    }

    // MARK: - Добавление записи
    func addRecord(_ record: Record) async throws {
        try db.collection(collection)
            .document(record.id.uuidString)
            .setData(from: record)
    }

    // MARK: - Получение всех записей текущего пользователя
    func fetchRecords(for userId: UUID) async throws -> [Record] {
        let snapshot = try await db.collection(collection)
            .whereField("userId", isEqualTo: userId.uuidString) // ✅ правильный UUID как строка
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            try document.data(as: Record.self)
        }
    }

    // MARK: - Обновление записи
    func updateRecord(_ record: Record) async throws {
        try db.collection(collection)
            .document(record.id.uuidString)
            .setData(from: record, merge: true)
    }

    // MARK: - Удаление записи
    func deleteRecord(_ recordId: UUID) async throws {
        try await db.collection(collection)
            .document(recordId.uuidString)
            .delete()
    }
}

