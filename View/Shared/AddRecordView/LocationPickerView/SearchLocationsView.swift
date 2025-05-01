//
//  SearchLocationsView.swift
//  Coffee
//
//  Created by Andrei on 06.02.2025.
//

import SwiftUI
import CoreLocation

struct SearchLocationsView: View {
    @Binding var navigationPath: [NewRecordRoute]
    @Binding var locationPickerViewModel: LocationPickerViewModel
    
    @State var locationSearchViewModel = LocationSearchViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Search location", text: $locationSearchViewModel.queryFragment)
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(.gray)
            }
            .padding(.vertical, 10)
            
            Divider()
                .padding(.vertical)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(locationSearchViewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    locationSearchViewModel.selectLocation(result, locationPickerViewModel: locationPickerViewModel)
                                    navigationPath.removeLast()
                                    
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    SearchLocationsView(
        navigationPath: .constant([.searchLocation]),
        locationPickerViewModel: .constant(LocationPickerViewModel())
    )
}
