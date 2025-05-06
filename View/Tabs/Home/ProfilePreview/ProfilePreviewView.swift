//
//  UserInfo.swift
//  Coffee
//
//  Created by Andrei on 25.01.2025.
//

//import SwiftUI
//
//struct UserInfo: View {    
//    var body: some View {
//        HStack {
//            Image("user-2")
//                .resizable()
//                .scaledToFill()
//                .frame(width: 64, height: 64)
//                .clipShape(Circle())
//            
//            VStack(alignment: .leading) {
//                Text("John Doe")
//                    .font(.headline)
//                
//                Text("Canada, since JAN '25")
//                    .font(.caption)
//                    .fontWeight(.light)
//            }
//            
//            Spacer()
//            
//            Image(systemName: "crown")
//            Image(systemName: "medal")
//
//        }
//    }
//}
//
//#Preview {
//    UserInfo()
//}

import SwiftUI

struct ProfilPreviewView: View {
    @Environment(AuthViewModel.self) var authViewModel

    var body: some View {
        let user = authViewModel.currentUser

        HStack {
            Image("user-2")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(user?.fullName ?? "Имя Фамилия")
                    .font(.headline)

                if let country = user?.country, let date = user?.registrationDate {
                    Text("\(country) since \(formatted(date))")
                        .font(.caption)
                        .fontWeight(.light)
                }
            }

            Spacer()

            if let achievements = user?.achievements {
                ForEach(achievements.prefix(2), id: \.self) { _ in
                    Image(systemName: "star.fill") // заменишь на логику отображения значков
                }
            }
        }
    }

    func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM ''yy"
        return formatter.string(from: date).uppercased()
    }
}
