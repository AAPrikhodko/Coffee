//
//  PersonalStat.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import SwiftUI

struct PersonalStat: View {
    @Binding var recordsViewModel: RecordsViewModel
    
    var body: some View {

        VStack(alignment: .leading) {
            Text("Personal statistics")
                .font(.title)
                .foregroundStyle(.gray)
                .padding(.bottom)
            
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .foregroundStyle(.cyan)
                        Text("\(recordsViewModel.records.count)")
                            .font(.title)
                            .monospaced()
                        Text("cups of coffee")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Image(systemName: "mappin")
                            .foregroundStyle(.blue)
                            .padding(.trailing, 24)
                        Text("48")
                            .monospaced()
                            .font(.title)
                        Text("places")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    
                    HStack {
                        Image(systemName: "globe")
                            .foregroundStyle(.red)
                            .padding(.trailing, 24)
                        Text("12")
                            .monospaced()
                            .font(.title)
                        Text("countries")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .padding()
                .overlay() {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(.gray)
                }
                
            }
        }
    }
}

#Preview {
    PersonalStat(
        recordsViewModel: .constant(RecordsViewModel())
    )
}
