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
    @State private var newRecord: Record = Record(
        id: UUID(),
        type: .americano,
        size: ._300,
        price: 0,
        place: Place(
            id: UUID(),
            name: "",
            type: .cafe
        )
    )
    
    @State private var selectedCoffeeType: CoffeeType = .americano
    @State private var selectedSize: CoffeeSize = ._300
    @State private var price: Double = 2.99
    @State private var selectedDate = Date()
    @State private var selectedPlaceType: PlaceType = .cafe
    
    @State private var address: String = ""
    @State private var coordinate: CLLocationCoordinate2D?
    
    @State private var newRecordState: NewRecordState = .collectingData
    
    var body: some View {
        ZStack {
            if newRecordState == .collectingData {
                NavigationStack{
                    Form {
                        Section("What drink?") {
                            Picker("Type", selection: $selectedCoffeeType) {
                                ForEach(CoffeeType.allCases, id: \.self) { type in
                                    Text(type.title).tag(type)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                            Picker("Size", selection: $selectedSize) {
                                ForEach(CoffeeSize.allCases, id: \.self) { size in
                                    Text(size.title + "ml").tag(size)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                            HStack {
                                Text("Price:")
                                Spacer()
                                Text("$ " + "\(String(format: "%.2f", price))")
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Section("What date?") {
                            DatePicker(
                                "Date",
                                selection: $selectedDate,
                                displayedComponents: .date
                            )
                         .datePickerStyle(CompactDatePickerStyle())
                        }
                        
                        Section("What place?") {
                            MapViewRepresentable()
                                .frame(height: 200)
                                .listRowInsets(EdgeInsets())
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        newRecordState = .fullMap
                                    }
                                }
                            
                            TextField("Address", text: $address)
                            
                            Picker("Type", selection: $selectedPlaceType) {
                                ForEach(PlaceType.allCases, id: \.self) { type in
                                    Text(type.title).tag(type)
                                }
                            }
                            .pickerStyle(.navigationLink)
                            
                        }
                    }
                    .navigationTitle("New Record")
                    .navigationDestination(for: Double.self) {price in
                        Text("Hello from price")
                    }
                    .toolbar {
                        Button {
                            isSheetShown = false
                            print("Added")
                        } label: {
                            Text("Add")
                        }
                        .padding()

                    }
                }
            } else {
                FullMapView(newRecordState: $newRecordState)
            }
        }
    }
}

#Preview {
    AddRecordView(isSheetShown: .constant(false))
        .environmentObject(LocationSearchViewModel())
}
