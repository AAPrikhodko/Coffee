//
//  UserInfo.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

import SwiftUI

struct UserInfo: View {    
    var body: some View {
        HStack {
            Image("user-2")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text("John Doe")
                    .font(.headline)
                
                Text("Canada, since JAN '25")
                    .font(.caption)
                    .fontWeight(.light)
            }
            
            Spacer()
            
            Image(systemName: "crown")
            Image(systemName: "medal")

        }
    }
}

#Preview {
    UserInfo()
}
