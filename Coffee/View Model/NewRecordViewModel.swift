//
//  NewRecordViewModel.swift
//  Coffee
//
//  Created by Andrei on 03.02.2025.
//

import Foundation
import CoreLocation

class NewRecordViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var record: Record = Record(
        id: UUID(),
        userId: UUID(),
        drinkType: .americano,
        drinkSize: .ml300,
        price: 10,
        date: Date(),
        place: Place(
            id: UUID(),
            address: "",
            type: .cafe
        )
    )
    
    func updateLocation(_ location: CLLocation) {
        self.record.place.location = location
    }
    
    func updateAddress(_ address: String) {
        self.record.place.address = address
    }
    
    func updateAddressByLocation(_ location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            DispatchQueue.main.async { // ✅ Ensures updates happen on the main thread
                if let error = error {
                    self.record.place.address = ""
                    print(error.localizedDescription)
                    return
                }

                if let placemark = placemarks?.first {
                    let street = placemark.thoroughfare ?? "Unknown Street"
                    let city = placemark.locality ?? "Unknown City"
                    let country = placemark.country ?? "Unknown Country"

                    self.record.place.address = "\(street), \(city), \(country)"
                } else {
                    self.record.place.address = ""
                }
            }
        }
    }
}
