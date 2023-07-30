//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    @State private var showAddressAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.orderDetails.name)
                TextField("Street Address", text: $order.orderDetails.address)
                TextField("City", text: $order.orderDetails.city)
                TextField("Zip", text: $order.orderDetails.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Checkout")
                }
                
            }
            .disabled(order.orderDetails.hasValidDetails == false)
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
