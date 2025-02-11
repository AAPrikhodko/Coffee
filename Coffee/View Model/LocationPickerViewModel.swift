//
//  LocationPickerViewModel.swift
//  Coffee
//
//  Created by Andrei on 11.02.2025.
//

import Foundation
import CoreLocation

@Observable
class LocationPickerViewModel: NSObject, CLLocationManagerDelegate {
    
    @ObservationIgnored let manager = CLLocationManager()
    @ObservationIgnored let geocoder = CLGeocoder()
    
    var isAuthorized: Bool = false
    var selectedLocation: CLLocation = CLLocation(latitude: 0, longitude: 0) {
        didSet {
            updateAddress()
        }
    }
    var selectedLocationAddress: String = "No data"
    
    override init() {
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(" didUpdateLocations: \(locations)")
        guard let currentLocation = locations.last else { return }
        selectedLocation = currentLocation
    }
    

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
        default:
            isAuthorized = true
            startLocationServices()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
    func updateAddress() {
        geocoder.reverseGeocodeLocation(selectedLocation) { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first else { return }
            
            let currentAddress = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            
            self?.selectedLocationAddress = currentAddress.isEmpty ? "No data" : currentAddress
        }
    }
    
    func setUserLocation() {
        if let location = manager.location {
            self.selectedLocation = location
        }
    }
}

