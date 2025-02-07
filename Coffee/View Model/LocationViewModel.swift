//
//  LocationViewModel.swift
//  Coffee
//
//  Created by Andrei on 05.02.2025.
//

import Foundation
import MapKit

@Observable
class LocationViewModel: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    var currentLocation: CLLocation? {
        didSet {
            updateCurrentAddress()
        }
    }
    var currentAddress: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location
        locationManager.stopUpdatingLocation()
    }
    
    private func updateCurrentAddress() {
        guard let location = currentLocation else { return }
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            
            let address = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            
            self?.currentAddress = address.isEmpty ? "Unknown Location" : address
        }
    }
    
}
