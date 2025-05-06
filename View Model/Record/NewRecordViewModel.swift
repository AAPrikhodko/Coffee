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
import FirebaseAuth
import FirebaseFirestore
import CoreLocation
import MapKit
import SwiftUI

@Observable
class NewRecordViewModel: ObservableObject {
    var drinkType: DrinkType = .americano
    var drinkSize: DrinkSize = .ml250
    var price: Double = 0
    var currency: Currency = .usd
    var date: Date = Date()
    var place: Place = Place(
        id: UUID(),
        coordinates: Coordinates(latitude: 0, longitude: 0),
        address: "",
        type: .cafe
    )
    
    var isSaving: Bool = false
    var errorMessage: String?
    
    private let authViewModel: AuthViewModel
    private let recordsViewModel: RecordsViewModel

    init(authViewModel: AuthViewModel, recordsViewModel: RecordsViewModel) {
        self.authViewModel = authViewModel
        self.recordsViewModel = recordsViewModel
    }

    func save() async -> Bool {
        guard let user = authViewModel.currentUser else {
            errorMessage = "Пользователь не найден"
            return false
        }

        let newRecord = Record(
            id: UUID(),
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
            try await recordsViewModel.addRecord(newRecord)
            return true
        } catch {
            errorMessage = "Ошибка при сохранении: \(error.localizedDescription)"
            return false
        }
    }

    func updateCoordinates(_ coordinates: Coordinates) {
        place.coordinates = coordinates
    }

    func updateAddressByLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async {
                if let placemark = placemarks?.first {
                    let street = placemark.thoroughfare ?? "Street"
                    let city = placemark.locality ?? "City"
                    let country = placemark.country ?? "Country"
                    self.place.address = "\(street), \(city), \(country)"
                } else {
                    self.place.address = "Unknown address"
                }
            }
        }
    }
}
