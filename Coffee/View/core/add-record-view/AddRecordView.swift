//
//  AddRecordView.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import SwiftUI
import MapKit

struct AddRecordView: View {
    @Binding var isSheetShown: Bool
    @Binding var recordsViewModel: RecordsViewModel
    
    @StateObject var recordViewModel = NewRecordViewModel()
    @State private var navigationPath = [NewRecordRoute]()
    
    @State private var locationViewModel = LocationViewModel()
    @State private var locationPickerViewModel = LocationPickerViewModel()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("What drink?") {
                    Picker("Type", selection: $recordViewModel.record.type) {
                        ForEach(CoffeeType.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Size", selection: $recordViewModel.record.size) {
                        ForEach(CoffeeSize.allCases, id: \.self) { size in
                            Text(size.title + "ml").tag(size)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    HStack {
                        Text("Price:")
                        Spacer()
                        Text("$ " + "\(String(format: "%.2f", recordViewModel.record.price))")
                            .foregroundStyle(.gray)
                    }
                }
                
                Section("What date?") {
                    DatePicker(
                        "Date",
                        selection: $recordViewModel.record.date,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                }
                
                Section("What place?") {
                    PreviewMapView(
                        navigationPath: $navigationPath,
                        locationViewModel: $locationViewModel,
                        locationPickerViewModel: $locationPickerViewModel
                    )
                        .listRowInsets(EdgeInsets())
                    
                    HStack {
                        Text("Address")
                        Spacer()
                        Text(locationViewModel.address)
                            .foregroundStyle(.gray)
                    }
                    
                    Picker("Type", selection: $recordViewModel.record.place.type) {
                        ForEach(PlaceType.allCases, id: \.self) { type in
                            Text(type.title).tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                }
            }
            .navigationTitle("New Record")
            .navigationDestination(for: NewRecordRoute.self) {route in
                switch (route) {
                case .mapPicker:
                    FullMapView2(
                        navigationPath: $navigationPath,
                        locationViewModel: $locationViewModel,
                        locationPickerViewModel: $locationPickerViewModel
                    )
                case .searchLocation:
                    SearchLocationsView(
                        navigationPath: $navigationPath,
                        locationPickerViewModel: $locationPickerViewModel
                    )
                }
            }
            .toolbar {
                Button {
                    isSheetShown = false
                    recordsViewModel.addRecord(recordViewModel.record)
                } label: {
                    Text("Add")
                }
                .padding()
                
            }
        }
    }
}

#Preview {
    AddRecordView(
        isSheetShown: .constant(true),
        recordsViewModel: .constant(RecordsViewModel())
    )
}
