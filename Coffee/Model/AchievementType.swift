//
//  AchievementType.swift
//  Coffee
//
//  Created by Andrei on 29.04.2025.
//

import Foundation

enum AchievementType: String, Codable, CaseIterable, Identifiable {
    case newcomer
    case cappuccinoLover
    case experimenter
    case morningDrinker
    case consistentDrinker
    case bigSpender
    case mapExplorer
    case cityHopper

    var id: String { rawValue }

    var title: String {
        switch self {
        case .newcomer: return "Новичок"
        case .cappuccinoLover: return "Любитель капучино"
        case .experimenter: return "Экспериментатор"
        case .morningDrinker: return "Любитель утреннего кофе"
        case .consistentDrinker: return "Постоянный кофеман"
        case .bigSpender: return "Большой транжира"
        case .mapExplorer: return "Кофейный исследователь"
        case .cityHopper: return "Путешественник по кофе"
        }
    }

    var icon: String {
        switch self {
        case .newcomer: return "star.fill"
        case .cappuccinoLover: return "cup.and.saucer.fill"
        case .experimenter: return "wand.and.rays"
        case .morningDrinker: return "sunrise.fill"
        case .consistentDrinker: return "calendar"
        case .bigSpender: return "creditcard.fill"
        case .mapExplorer: return "map.fill"
        case .cityHopper: return "airplane"
        }
    }
}
