//
//  CoffeeTypeCarousel.swift
//  Coffee
//
//  Created by Andrei on 26.01.2025.
//

import SwiftUI

struct CoffeeTypeCarousel: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    private let images: [String] = ["Americano", "Latte", "Cappuccino"]
    
    var body: some View {

            VStack {
                ZStack {
                    ForEach(0..<images.count, id: \.self) { index in
                        VStack {
                            Image(images[index])
                                .resizable()
                                .frame(width: 200, height: 150)
                                .scaledToFit()
                                .opacity(currentIndex == index ? 1.0 : 0.5)
                                .scaleEffect(currentIndex == index ? 1 : 0.6)
                                .offset(x: CGFloat(index - currentIndex) * 200 + dragOffset, y: 0)
                            
                            Text(images[index])
                                .font(.title)
                                .padding()
                                .frame(width: 200)
                                .background(Color(.systemGray5))
                                .cornerRadius(12)
                                .shadow(radius: 4)
                                .opacity(currentIndex == index ? 1.0 : 0.5)
                                .scaleEffect(currentIndex == index ? 1 : 0.8)
                                .offset(x: CGFloat(index - currentIndex) * 200 + dragOffset, y: 0)
                        }
                    }
                }
                .gesture(
                    DragGesture()
                        .onEnded({ value in
                            let threshold: CGFloat = 50
                            if value.translation.width > threshold {
                                withAnimation {
                                    currentIndex = max(0, currentIndex - 1)
                                }
                            } else if value.translation.width < -threshold {
                                withAnimation {
                                    currentIndex = min(images.count - 1, currentIndex + 1)
                                }
                            }
                        })
                )
                
//                HStack {
//                    Button {
//                        withAnimation {
//                            currentIndex = max(0, currentIndex - 1)
//                        }
//                    } label: {
//                        Image(systemName: "arrow.left")
//                            .font(.title)
//                    }
//                    
//                    Spacer()
//                    
//                    Button {
//                        withAnimation {
//                            currentIndex = min(images.count - 1, currentIndex + 1)
//                        }
//                    } label: {
//                        Image(systemName: "arrow.right")
//                            .font(.title)
//                    }
//                    
//                }
//                .frame(width: 200)
//                .padding()
            }
        }

}

#Preview {
    CoffeeTypeCarousel()
}
