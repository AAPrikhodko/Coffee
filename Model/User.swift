//
//  User.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    
    var firstName: String
    var lastName: String
    var avatarURL: String?
    var records: [Record]
    var country: String
    var registrationDate: Date
    var favoriteDrink: DrinkType?
    var achievements: [AchievementType]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    var coffeeRecordsCount: Int {
        return records.count
    }
}
