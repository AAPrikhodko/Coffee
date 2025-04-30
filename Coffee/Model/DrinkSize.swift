//
//  DrinkSize.swift
//  Coffee
//
//  Created by Andrei on 29.04.2025.
//

import Foundation

enum DrinkSize: Int, CaseIterable, Codable, Identifiable {
    case ml50 = 50
    case ml100 = 100
    case ml150 = 150
    case ml200 = 200
    case ml250 = 250
    case ml300 = 300
    case ml350 = 350
    case ml400 = 400
    case ml450 = 450
    case ml500 = 500
    
    var id: Int { rawValue }

    var displayName: String {
        "\(rawValue) ml"
    }
}

