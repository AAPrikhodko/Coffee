//
//  FirebaseRecordRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation
import FirebaseFirestore

final class FirebaseRecordRepository: RecordRepository {
    private let db = Firestore.firestore()
    private let collection = "records"

    func fetchRecords(for userId: UUID) async throws -> [Record] {
        let snapshot = try await db.collection(collection)
            .whereField("userId", isEqualTo: userId.uuidString)
            .getDocuments()

        return try snapshot.documents.compactMap { document in
            try document.data(as: Record.self)
        }
    }

    func addRecord(_ record: Record) async throws {
        try db.collection(collection)
            .document(record.id.uuidString)
            .setData(from: record)
    }

    func deleteRecord(withId id: UUID) async throws {
        try await db.collection(collection)
            .document(id.uuidString)
            .delete()
    }
}
