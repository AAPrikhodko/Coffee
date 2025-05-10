//
//  NewRecordViewModel.swift
//  Coffee
//
//  Created by Andrei on 03.02.2025.
//

//import Foundation
//import CoreLocation
//
//class NewRecordViewModel: ObservableObject {
//    
//    // MARK: - Properties
//    
//    @Published var record: Record = Record(
//        id: UUID(),
//        userId: UUID(),
//        drinkType: .americano,
//        drinkSize: .ml300,
//        price: 10,
//        date: Date(),
//        place: Place(
//            id: UUID(),
//            address: "",
//            type: .cafe
//        )
//    )
//    
//    func updateCoordinates(_ coordinates: Coordinates) {
//        self.record.place.coordinates = coordinates
//    }
//    
//    func updateAddress(_ address: String) {
//        self.record.place.address = address
//    }
//    
//    func updateAddressByLocation(_ location: CLLocation) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            DispatchQueue.main.async { 
//                if let error = error {
//                    self.record.place.address = ""
//                    print(error.localizedDescription)
//                    return
//                }
//
//                if let placemark = placemarks?.first {
//                    let street = placemark.thoroughfare ?? "Unknown Street"
//                    let city = placemark.locality ?? "Unknown City"
//                    let country = placemark.country ?? "Unknown Country"
//
//                    self.record.place.address = "\(street), \(city), \(country)"
//                } else {
//                    self.record.place.address = ""
//                }
//            }
//        }
//    }
//}
//
//import Foundation
//import FirebaseAuth
//import MapKit
//
//@MainActor
//final class NewRecordViewModel: ObservableObject {
//    // MARK: - Поля из формы
//    @Published var drinkType: DrinkType = .americano
//    @Published var drinkSize: DrinkSize = .ml250
//    @Published var price: Double = 0
//    @Published var currency: String = "USD"
//    @Published var date: Date = Date()
//    @Published var place: Place = Place(
//        id: UUID(),
//        coordinates: Coordinates(latitude: 0, longitude: 0),
//        address: "",
//        type: .cafe
//    )
//
//    @Published var isSaving = false
//    @Published var errorMessage: String?
//
//    // MARK: - Автоматический доступ к окружению
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @EnvironmentObject var recordsViewModel: RecordsViewModel
//
//    private let recordRepository: RecordRepository = FirebaseRecordRepository()
//    
//    // MARK: - Сохранение
//    func save() async -> Bool {
//        guard let user = authViewModel.currentUser else {
//            errorMessage = "Пользователь не найден"
//            return false
//        }
//
//        isSaving = true
//        errorMessage = nil
//
//        let record = Record(
//            id: UUID(),
//            userId: user.id.uuidString,
//            drinkType: drinkType,
//            drinkSize: drinkSize,
//            price: price,
//            date: date,
//            place: place
//        )
//
//        do {
//            try await recordRepository.addRecord(record)
//            recordsViewModel.records.append(record)
//            isSaving = false
//            return true
//        } catch {
//            errorMessage = error.localizedDescription
//            isSaving = false
//            return false
//        }
//    }
//
//    // MARK: - Обновление координат
//    func updateCoordinates(_ coordinates: Coordinates) {
//        place.coordinates = coordinates
//    }
//
//    // MARK: - Обновление адреса по строке
//    func updateAddress(_ address: String) {
//        place.address = address
//    }
//
//    // MARK: - Обратное геокодирование
//    func updateAddressByLocation(_ location: CLLocation) {
//        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print("❌ Геокодирование: \(error.localizedDescription)")
//                    self.place.address = ""
//                    return
//                }
//
//                if let placemark = placemarks?.first {
//                    let street = placemark.thoroughfare ?? "Unknown Street"
//                    let city = placemark.locality ?? "Unknown City"
//                    let country = placemark.country ?? "Unknown Country"
//                    self.place.address = "\(street), \(city), \(country)"
//                } else {
//                    self.place.address = ""
//                }
//            }
//        }
//    }
//}

import Foundation
import CoreLocation
import MapKit
import SwiftUI

@Observable
class NewRecordViewModel: ObservableObject {
    var drinkType: DrinkType
    var drinkSize: DrinkSize
    var price: Double
    var currency: Currency
    var date: Date
    var placeType: PlaceType
    var existingRecordId: UUID?
    var existingPlaceId: UUID?

    var isSaving: Bool = false
    var errorMessage: String?

    private let authViewModel: AuthViewModel
    private let recordsViewModel: RecordsViewModel

    // MARK: - Инициализация
    init(
        authViewModel: AuthViewModel,
        recordsViewModel: RecordsViewModel,
        editingRecord: Record? = nil,
        defaultDate: Date = Date()
    ) {
        self.authViewModel = authViewModel
        self.recordsViewModel = recordsViewModel

        if let record = editingRecord {
            self.existingRecordId = record.id
            self.existingPlaceId = record.place.id
            self.drinkType = record.drinkType
            self.drinkSize = record.drinkSize
            self.price = record.price
            self.currency = record.currency
            self.date = record.date
            self.placeType = record.place.type
        } else {
            self.drinkType = .americano
            self.drinkSize = .ml250
            self.price = 0
            self.currency = .usd
            self.date = defaultDate
            self.placeType = .cafe
        }
    }

    // MARK: - Сохранение
    func save(locationViewModel: LocationViewModel) async -> Bool {
        guard let user = authViewModel.currentUser else {
            errorMessage = "User not found"
            return false
        }

        let place = Place(
            id: existingPlaceId ?? UUID(),
            coordinates: locationViewModel.coordinates,
            address: locationViewModel.address,
            type: placeType
        )

        let record = Record(
            id: existingRecordId ?? UUID(),
            userId: user.id.uuidString,
            drinkType: drinkType,
            drinkSize: drinkSize,
            price: price,
            currency: currency,
            date: date,
            place: place
        )

        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            if existingRecordId != nil {
                try await recordsViewModel.updateRecord(record)
            } else {
                try await recordsViewModel.addRecord(record)
            }
            return true
        } catch {
            errorMessage = "Failed to save: \(error.localizedDescription)"
            return false
        }
    }
}


