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
    @State private var navigationPath: [NewRecordRoute] = []
    @State private var isEditingPrice = false
    @FocusState private var isPriceFieldFocused: Bool
    
    private let editingRecord: Record?

    init(
        isSheetShown: Binding<Bool>,
        authViewModel: AuthViewModel,
        recordsViewModel: RecordsViewModel,
        editingRecord: Record? = nil,
        defaultDate: Date = Date()
    ) {
        self._isSheetShown = isSheetShown
        self.editingRecord = editingRecord
        self._newRecordViewModel = State(
            initialValue: NewRecordViewModel(
                authViewModel: authViewModel,
                recordsViewModel: recordsViewModel,
                editingRecord: editingRecord,
                defaultDate: defaultDate
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
                        Text("Price")
                        Spacer()
                        
                        HStack(spacing: 10) {
                            if isEditingPrice {
                                TextField("0.00", value: $newRecordViewModel.price, format: .number.precision(.fractionLength(2)))
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.trailing)
                                    .frame(width: 80)
                                    .focused($isPriceFieldFocused)
                                    .onSubmit {
                                        isEditingPrice = false
                                    }
                                    .onChange(of: isPriceFieldFocused) {
                                        if !isPriceFieldFocused {
                                            isEditingPrice = false
                                        }
                                    }
                            } else {
                                Text(String(format: "%.2f", newRecordViewModel.price))
                                    .foregroundStyle(.gray)
                                    .frame(width: 80, alignment: .trailing)
                                    .onTapGesture {
                                        withAnimation {
                                            isEditingPrice = true
                                            isPriceFieldFocused = true
                                        }
                                    }
                            }

                            Menu {
                                ForEach(Currency.allCases) { currency in
                                    Button(currency.displayName) {
                                        newRecordViewModel.currency = currency
                                    }
                                }
                            } label: {
                                Text(newRecordViewModel.currency.displayName)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(6)
                            }
                        }
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
                        locationViewModel: $locationViewModel
                    )
                        .listRowInsets(EdgeInsets())
                    
                    HStack {
                        Text("Address")
                        Spacer()
                        Text(locationViewModel.address)
                            .foregroundStyle(.gray)
                    }
                    
                    Picker("Type", selection: $newRecordViewModel.placeType) {
                        ForEach(PlaceType.allCases, id: \.self) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                }
            }
            .navigationTitle(editingRecord == nil ? "New Record" : "Edit Record")
            .navigationDestination(for: NewRecordRoute.self) {route in
                switch (route) {
                case .mapPicker:
                    FullMapView2(
                        navigationPath: $navigationPath,
                        locationViewModel: $locationViewModel
                    )
                case .searchLocation(let locationFullMapViewModel):
                    SearchLocationsView(
                        navigationPath: $navigationPath,
                        locationFullMapViewModel: locationFullMapViewModel
                    )
                }
            }
            .toolbar {
                Button {
                    Task {
                        let success = await newRecordViewModel.save(locationViewModel: locationViewModel)
                        if success {
                            isSheetShown = false
                        }
                    }
                } label: {
                    if newRecordViewModel.isSaving {
                        ProgressView()
                    } else {
                        Text(editingRecord == nil ? "Add" : "Save")
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

#Preview {
    AddRecordView(
        isSheetShown: .constant(false),
        authViewModel: AuthViewModel(),
        recordsViewModel: RecordsViewModel(user: .dummy))
}
