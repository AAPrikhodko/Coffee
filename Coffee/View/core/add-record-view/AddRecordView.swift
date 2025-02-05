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
    
    @StateObject var recordViewModel = NewRecordViewModel()
    
    @State private var newRecordState: NewRecordState = .collectingData
    let mapView = MKMapView()
    
    var body: some View {
        ZStack {
            if newRecordState == .collectingData {
                NavigationStack{
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
                            MapViewRepresentable(mapView: mapView, recordViewModel: recordViewModel)
                                .frame(height: 200)
                                .listRowInsets(EdgeInsets())
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        newRecordState = .fullMap
                                    }
                                }
                            
                            Text(recordViewModel.record.place.address)
                            
                            Picker("Type", selection: $recordViewModel.record.place.type) {
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
                FullMapView(newRecordState: $newRecordState, recordViewModel: recordViewModel, mapView: mapView)
            }
        }
    }
}

#Preview {
    AddRecordView(isSheetShown: .constant(false))
}
