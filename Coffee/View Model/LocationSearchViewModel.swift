//
//  LocationSearchViewModel.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import Foundation
import MapKit
import SwiftUICore

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var results: [MKLocalSearchCompletion] = []
    @Published var selectedlocationCoordinate: CLLocationCoordinate2D?
    @Published var selectedLoationAddress: String?
    
    @EnvironmentObject var recordViewModel: NewRecordViewModel
    
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
    
    func selectLocation(_ localSearch: MKLocalSearchCompletion) {
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                print("Error searching: \(error.localizedDescription)")
                return
                
            }
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate

            let street = item.placemark.thoroughfare ?? ""
            let city = item.placemark.locality ?? ""
            let country = item.placemark.country ?? ""
            let houseNumber = item.placemark.subThoroughfare ?? ""
            
            self.selectedLoationAddress = "\(houseNumber) \(street), \(city), \(country)"
            self.selectedlocationCoordinate = coordinate
            
            

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
