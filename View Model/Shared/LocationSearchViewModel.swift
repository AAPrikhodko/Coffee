//
//  LocationSearchViewModel.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import Foundation
import MapKit
import SwiftUICore

@Observable
class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    var results: [MKLocalSearchCompletion] = []
    var selectedlocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()
    var queryFragment : String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - lifecycle
    
    override init() {
        super.init()
        searchCompleter.delegate = self
        searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion, locationPickerViewModel: LocationPickerViewModel) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("Error searching: \(error.localizedDescription)")
                return
                
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
           
            self.selectedlocationCoordinate = coordinate
            locationPickerViewModel.selectedLocation = CLLocation(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
        }
    }
    
    func locationSearch(
        forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
        completion: @escaping(MKLocalSearch.CompletionHandler)) {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
            let search = MKLocalSearch(request: searchRequest)
            
            search.start(completionHandler: completion)
        }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
