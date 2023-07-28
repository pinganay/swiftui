//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/25/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select type of cupcake", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    .pickerStyle(.navigationLink)
                    
                    Stepper("Amount of cupcakes: \(order.cakeAmount)", value: $order.cakeAmount, in: 3...20)
                }
                
                Section {
                    Toggle("Do you want a special request?", isOn: $order.specialRequest.animation())
                    
                    if order.specialRequest {
                        Toggle("Do you want extra frosting?", isOn: $order.extraFrosting)
                        Toggle("Do you want extra sprinkles?", isOn: $order.extraSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }  
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
