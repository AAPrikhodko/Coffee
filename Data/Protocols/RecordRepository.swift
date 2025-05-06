//
//  RecordRepository.swift
//  Coffee
//
//  Created by Andrei on 30.04.2025.
//

import Foundation

protocol RecordRepository {
    func addRecord(_ record: Record) async throws
    func fetchRecords(for userId: UUID) async throws -> [Record]
    func updateRecord(_ record: Record) async throws
    func deleteRecord(_ recordId: UUID) async throws
}
