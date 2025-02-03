//
//  CoffeePriceInput.swift
//  Coffee
//
//  Created by Andrei on 27.01.2025.
//

import SwiftUI

struct CoffeeItem: Identifiable {
    let id = UUID()
    var name: String
    var price: String
    var currency: String
}

struct CoffeePriceInput: View {
    @State private var coffeeList = [
        CoffeeItem(name: "Americano", price: "2.99", currency: "USD"),
        CoffeeItem(name: "Latte", price: "3.99", currency: "USD"),
        CoffeeItem(name: "Cappuccino", price: "4.49", currency: "USD"),
        CoffeeItem(name: "Mocha", price: "4.99", currency: "USD")
    ]
    
    let currencies = ["USD", "EUR", "GBP", "JPY"]

    var body: some View {
        List($coffeeList) { $coffee in
            HStack {
                Text(coffee.name)
                    .font(.headline)

                Spacer()

                HStack {
                    Picker("", selection: $coffee.currency) {
                        ForEach(currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    TextField("0.00", text: $coffee.price)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                .frame(width: 150)
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
            }
            .padding(.vertical, 5)
        }
        .navigationTitle("Coffee Prices")
    }
}

#Preview {
    CoffeePriceInput()
}
