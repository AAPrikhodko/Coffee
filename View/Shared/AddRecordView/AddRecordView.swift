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

    @State private var newRecordViewModel: NewRecordViewModel
    @State private var locationViewModel = LocationViewModel()
    @State private var locationPickerViewModel = LocationPickerViewModel()
    @State private var navigationPath: [NewRecordRoute] = []

    init(
        isSheetShown: Binding<Bool>,
        authViewModel: AuthViewModel,
        recordsViewModel: RecordsViewModel
    ) {
        self._isSheetShown = isSheetShown
        self._newRecordViewModel = State(
            initialValue: NewRecordViewModel(
                authViewModel: authViewModel,
                recordsViewModel: recordsViewModel
            )
        )
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            Form {
                Section("What drink?") {
                    Picker("Type", selection: $newRecordViewModel.drinkType) {
                        ForEach(DrinkType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Picker("Size", selection: $newRecordViewModel.drinkSize) {
                        ForEach(DrinkSize.allCases, id: \.self) { size in
                            Text(size.displayName).tag(size)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    HStack {
                        Text("Price:")
                        Spacer()
                        Text("$ " + "\(String(format: "%.2f", newRecordViewModel.price))")
                            .foregroundStyle(.gray)
                    }
                }
                
                Section("What date?") {
                    DatePicker(
                        "Date",
                        selection: $newRecordViewModel.date,
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
                    
                    Picker("Type", selection: $newRecordViewModel.place.type) {
                        ForEach(PlaceType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
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
                    Task {
                        let success = await newRecordViewModel.save()
                        if success {
                            isSheetShown = false
                        }
                    }
                } label: {
                    if newRecordViewModel.isSaving {
                        ProgressView()
                    } else {
                        Text("Add")
                    }
                }
                .disabled(newRecordViewModel.isSaving)
            }
            .alert("Ошибка", isPresented: .constant(newRecordViewModel.errorMessage != nil)) {
                 Button("OK", role: .cancel) {
                     newRecordViewModel.errorMessage = nil
                 }
             } message: {
                 Text(newRecordViewModel.errorMessage ?? "")
             }
        }
    }
}
