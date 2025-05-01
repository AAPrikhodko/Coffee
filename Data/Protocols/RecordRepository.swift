//
//  RecordRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation

protocol RecordRepository {
    func fetchRecords(for userId: UUID) async throws -> [Record]
    func addRecord(_ record: Record) async throws
    func deleteRecord(withId id: UUID) async throws
}
