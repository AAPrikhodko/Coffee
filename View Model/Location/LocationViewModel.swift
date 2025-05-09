//
//  LocationViewModel.swift
//  Coffee
//
//  Created by Andrei on 05.02.2025.
//

import Foundation
import MapKit
import SwiftUI
import MapKit

@Observable
class LocationViewModel: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    @ObservationIgnored let geocoder = CLGeocoder()
    
    var mapCameraPosition: MapCameraPosition = .automatic
    var isAuthorized: Bool = false
    var address: String = "No data"
    
    private var _coordinates: Coordinates
    var coordinates: Coordinates {
        get {
            return _coordinates
        }
        set {
            if _coordinates != newValue { // Обновляем только если координаты изменились
                print("Coordinates updated: \(_coordinates) -> \(newValue)")
                _coordinates = newValue
                updateAddress()
                updateMapCameraPosition()
            } else {
                print("Coordinates not updated (no change): \(_coordinates)")
            }
        }
    }

    // Инициализатор с параметром initialCoordinates
    init(initialCoordinates: Coordinates? = nil) {
        if let initialCoordinates = initialCoordinates {
            print("Initial coordinates provided: \(initialCoordinates)")
            self._coordinates = initialCoordinates
        } else {
            print("No initial coordinates provided, using default")
            self._coordinates = Coordinates(latitude: 0, longitude: 0)
        }
        
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
        guard let currentLocation = locations.last else { return }
        let newCoordinates = Coordinates(from: currentLocation.coordinate)
        
        // Добавляем проверку, чтобы избежать установки одинаковых координат
        if _coordinates != newCoordinates {
            print("Location updated: \(_coordinates) -> \(newCoordinates)")
            coordinates = newCoordinates
        } else {
            print("Location unchanged: \(_coordinates)")
        }
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
        print("Location update failed: \(error.localizedDescription)")
    }

    private func updateAddress() {
        print("Updating address for coordinates: \(coordinates)")
        geocoder.reverseGeocodeLocation(coordinates.clLocation) { [weak self] placemarks, _ in
            guard let placemark = placemarks?.first else {
                print("No address found for coordinates: \(self?.coordinates ?? Coordinates(latitude: 0, longitude: 0))")
                return
            }
            
            let currentAddress = [
                placemark.subThoroughfare,
                placemark.thoroughfare,
                placemark.locality,
                placemark.administrativeArea,
                placemark.country
            ].compactMap { $0 }.joined(separator: ", ")
            
            self?.address = currentAddress.isEmpty ? "No data" : currentAddress
            print("Updated address: \(self?.address ?? "No data")")
        }
    }

    func updateMapCameraPosition() {
        print("Updating map camera position to coordinates: \(coordinates)")
        let region: MKCoordinateRegion = MKCoordinateRegion(
            center: coordinates.asCLLocationCoordinate2D,
            span: MKCoordinateSpan(latitudeDelta: 0.008, longitudeDelta: 0.008)
        )
        withAnimation {
            mapCameraPosition = .region(region)
        }
    }

    func updateCoordinates(_ coordinates: Coordinates) {
        self.coordinates = coordinates
    }

    func setUserLocation() {
        if let location = manager.location {
            let newCoordinates = Coordinates(from: location)
            // Проверяем, если текущие координаты отличаются от новых
            if _coordinates != newCoordinates {
                print("User location updated: \(_coordinates) -> \(newCoordinates)")
                coordinates = newCoordinates
            } else {
                print("User location unchanged: \(_coordinates)")
            }
        }
    }
}

