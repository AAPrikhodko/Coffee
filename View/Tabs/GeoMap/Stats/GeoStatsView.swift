//
//  GeoStatsView.swift
//  Coffee
//
//  Created by Andrei on 11.05.2025.
//

import SwiftUI
import Charts

struct GeoStatsView: View {
    @Environment(RecordsViewModel.self) private var recordsViewModel

    @State private var selectedCountry: String = "All countries"
    @State private var selectedMetric: Metric = .cups

    private var availableCountries: [String] {
        let countries = Set(recordsViewModel.records.compactMap { $0.place.countryCode })
        return ["All countries"] + countries.sorted()
    }

    private var filteredRecords: [Record] {
        recordsViewModel.records.filter {
            selectedCountry == "All countries" || $0.place.countryCode == selectedCountry
        }
    }

    private var groupedData: [(label: String, value: Double)] {
        if selectedCountry == "All countries" {
            let grouped = Dictionary(grouping: filteredRecords) { $0.place.countryCode ?? "Unknown" }
            return grouped.map { (label: $0.key, value: selectedMetric.value(from: $0.value)) }
        } else {
            let grouped = Dictionary(grouping: filteredRecords) { $0.place.cityName }
            return grouped.map { (label: $0.key, value: selectedMetric.value(from: $0.value)) }
        }
    }

    private var sortedData: [(label: String, value: Double)] {
        groupedData.sorted { $0.value > $1.value }
    }

    private var currencySymbol: String? {
        filteredRecords.first?.currency.symbol
    }

    private var totalValueText: Text {
        let valueText: Text = {
            if selectedMetric == .cups {
                return Text("\(Int(filteredRecords.count)) cups").foregroundColor(.red)
            } else {
                let total = filteredRecords.reduce(0) { $0 + $1.price }
                let symbol = currencySymbol ?? ""
                return Text(String(format: "%@%.2f", symbol, total)).foregroundColor(.red)
            }
        }()

        if selectedCountry == "All countries" {
            let action = selectedMetric == .cups ? "enjoyed " : "spent "
            return Text("Across all countries, you've ") + Text(action) + valueText
        } else {
            let countryText = Text(selectedCountry).foregroundColor(.blue.opacity(0.8))
            let action = selectedMetric == .cups ? "enjoyed " : "spent "
            return Text("In ") + countryText + Text(", you've ") + Text(action) + valueText
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 🔹 Pickers
                VStack(spacing: 12) {
                    HStack {
                        Text("Show")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker("", selection: $selectedMetric.animation(.easeInOut)) {
                            ForEach(Metric.allCases) { metric in
                                Text(metric.title).tag(metric)
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 200)
                    }
                    .padding(.bottom, 8)

                    HStack {
                        Text("Country")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Menu {
                            ForEach(availableCountries, id: \.self) { country in
                                Button {
                                    withAnimation {
                                        selectedCountry = country
                                    }
                                } label: {
                                    Text(country)
                                }
                            }
                        } label: {
                            Text(selectedCountry)
                                .fontWeight(.medium)
                        }
                    }
                }
                .padding(.top, 8)

                Divider()

                // 🔹 Chart
                Chart(sortedData, id: \.label) { item in
                    BarMark(
                        x: .value(selectedMetric.title, item.value),
                        y: .value("Location", item.label)
                    )
                    .foregroundStyle(Color.accentColor)
                    .annotation(position: .trailing) {
                        Text(selectedMetric == .cups
                             ? "\(Int(item.value))"
                             : String(format: "%.2f", item.value))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .chartXAxis {
                    AxisMarks(position: .bottom, values: selectedMetric == .cups ? .stride(by: 1) : .automatic)
                }
                .animation(.easeInOut, value: selectedCountry)
                .animation(.easeInOut, value: selectedMetric)

                Divider()

                // 🔹 Description
                totalValueText
                    .font(.callout)
                    .padding(.top, 8)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Geo Stats")
        .navigationBarTitleDisplayMode(.inline)
    }

    enum Metric: String, CaseIterable, Identifiable {
        case cups
        case spent

        var id: String { rawValue }

        var title: String {
            switch self {
            case .cups: return "Total Cups"
            case .spent: return "Total Spent"
            }
        }

        func value(from records: [Record]) -> Double {
            switch self {
            case .cups: return Double(records.count)
            case .spent: return records.reduce(0) { $0 + $1.price }
            }
        }
    }
}
