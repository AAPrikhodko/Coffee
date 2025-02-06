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
    var currentLocation: CLLocation?
    
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
}
