//
//  LocationSearchView.swift
//  Coffee
//
//  Created by Andrei on 01.02.2025.
//

import SwiftUI

struct LocationSearchView: View {
    @Binding var newRecordState: NewRecordState
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    var body: some View {

        VStack {
            // headerView
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.horizontal)
                
                TextField("Search location...", text: $viewModel.queryFragment)
                    .foregroundColor(Color(.darkGray))
            }
            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
            .background(
                Capsule()
                    .fill(Color(.white))
                    .shadow(color: .black, radius: 5)
            )
            .padding(.horizontal)
            .padding(.top, 46)
            
            Divider()
                .padding(.vertical)
            
            // listView
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.results, id: \.self) { result in
                        LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    viewModel.selectLocation(result)
                                    newRecordState = .fullMap
                                }
                            }
                    }
                }
            }
        
        }
        .background(.white)
    }
}

#Preview {
    LocationSearchView(newRecordState: .constant(.searchLocations))
        .environmentObject(LocationSearchViewModel())
}
