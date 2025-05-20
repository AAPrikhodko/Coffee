//
//  ChartsTabView2.swift
//  Coffee
//
//  Created by Andrei on 20.05.2025.
//

import SwiftUI

struct ChartsTabView2: View {
    enum Measure: String, CaseIterable {
        case spent = "Spent", cups = "Cups", liters = "Liters"
    }

    enum ChartType: String, CaseIterable {
        case bar = "Bar", pie = "Pie"
    }

    enum PeriodStep: String, CaseIterable {
        case week = "Week", month = "Month", year = "Year"
    }

    enum GroupBy: String, CaseIterable {
        case coffeeType = "by Coffee type"
        case country = "by Country"
        case city = "by City"
    }

    @State private var selectedDateRange = Date()...Date()
    @State private var measure: Measure = .spent
    @State private var chartType: ChartType = .bar
    @State private var periodStep: PeriodStep = .month
    @State private var groupBy: GroupBy = .coffeeType
    @State private var selectedFilters: [String] = []

    var body: some View {
        VStack(spacing: 16) {
            // 🔹 Горизонтальный скролл фильтров
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    filterTag(title: "Период", removable: false)
                    ForEach(selectedFilters, id: \.self) { filter in
                        filterTag(title: filter)
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Информационный блок + переключатель
            HStack {
                VStack(alignment: .leading) {
                    Text("123")
                        .font(.largeTitle).bold()
                    Text(measure.rawValue)
                        .font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                HStack(spacing: 12) {
                    ForEach(Measure.allCases, id: \.self) { m in
                        Image(systemName: icon(for: m))
                            .padding(8)
                            .background(m == measure ? Color.accentColor.opacity(0.2) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture { measure = m }
                    }
                }
            }
            .padding(.horizontal)

            // 🔹 Карусель графиков
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<5) { index in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 280, height: 180)
                            .overlay(Text("Chart \(index + 1)"))
                    }
                }
                .padding(.horizontal)
            }

            // 🔹 Переключатели шагов и типа графика
            HStack {
                Picker("Step", selection: $periodStep) {
                    ForEach(PeriodStep.allCases, id: \.self) { step in
                        Text(step.rawValue)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()

                Picker("Chart", selection: $chartType) {
                    ForEach(ChartType.allCases, id: \.self) { type in
                        Image(systemName: type == .bar ? "chart.bar" : "chart.pie")
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 120)
            }
            .padding(.horizontal)

            // 🔹 Селектор группировки — теперь ближе к списку
            VStack(alignment: .leading, spacing: 0) {
                Picker("Group by", selection: $groupBy) {
                    ForEach(GroupBy.allCases, id: \.self) { group in
                        Text(group.rawValue)
                    }
                }
                .pickerStyle(.menu)
                .padding(.horizontal)
                .padding(.bottom, 4) // Минимальный отступ

                // 🔹 Список значений
                List {
                    ForEach(0..<10) { index in
                        Button {
                            addFilter("Value \(index + 1)")
                        } label: {
                            Text("Value \(index + 1)")
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .listRowBackground(Color.white) // Убираем стандартную заливку
                    }
                }
                .listStyle(.plain)
                .background(Color.white)
            }
        }
    }

    // MARK: — Вспомогательные функции

    func icon(for m: Measure) -> String {
        switch m {
        case .spent: return "dollarsign.circle"
        case .cups: return "cup.and.saucer"
        case .liters: return "drop"
        }
    }

    func addFilter(_ new: String) {
        if !selectedFilters.contains(new) {
            selectedFilters.append(new)
        }
    }

    func filterTag(title: String, removable: Bool = true) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.15))
                .cornerRadius(8)
            if removable {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .onTapGesture {
                        selectedFilters.removeAll { $0 == title }
                    }
            }
        }
    }
}
