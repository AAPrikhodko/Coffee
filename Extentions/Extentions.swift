//
//  Extentions.swift
//  Coffee
//
//  Created by Andrei on 11.05.2025.
//

extension Array where Element: Hashable {
    var uniqued: [Element] {
        Array(Set(self))
    }
}

extension Array {
    func group<Key: Hashable>(by keySelector: (Element) -> Key) -> [Key: [Element]] {
        Dictionary(grouping: self, by: keySelector)
    }
}
