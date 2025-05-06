//
//  User.swift
//  Coffee
//
//  Created by Andrei on 28.01.2025.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var firstName: String
    var lastName: String
    var avatarURL: String?
    var country: String
    var registrationDate: Date
    var favoriteDrink: DrinkType?
    var achievements: [AchievementType]
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
}

extension User {
    static var dummy: User {
        User(
            id: UUID(),
            firstName: "Test",
            lastName: "User",
            avatarURL: nil,
            country: "Nowhere",
            registrationDate: Date(),
            favoriteDrink: nil,
            achievements: [.newcomer]
        )
    }
}
