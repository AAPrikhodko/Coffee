//
//  User.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation

struct User: Identifiable {
    let id: UUID
    
    var name: String
    var email: String
    var avatar: String
    var records: [Record]
    
    var coffeeRecordsCount: Int {
        return records.count
    }
}
