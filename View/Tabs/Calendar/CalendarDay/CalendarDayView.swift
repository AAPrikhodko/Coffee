//
//  CalendarDayView.swift
//  Coffee
//
//  Created by Andrei on 08.05.2025.
//

import SwiftUI

struct CalendarDayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isInCurrentMonth: Bool
    let hasRecord: Bool

    var body: some View {
        Text(dayFormatter.string(from: date))
            .frame(width: 32, height: 32)
            .background(
                ZStack {
                    if isSelected {
                        Circle().fill(Color.accentColor)
                    } else if isToday {
                        Circle().stroke(Color.accentColor, lineWidth: 1.5)
                    } else if hasRecord {
                        Circle()
                            .fill(Color.accentColor.opacity(isInCurrentMonth ? 0.15 : 0.06))
                    }
                }
            )
            .foregroundColor(foregroundColor)
    }

    private var foregroundColor: Color {
        if isSelected {
            return .white
        } else if !isInCurrentMonth {
            return .gray.opacity(0.4)
        } else {
            return .primary
        }
    }

    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }
}
