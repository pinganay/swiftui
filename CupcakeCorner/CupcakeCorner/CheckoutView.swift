//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Anay Sahu on 7/26/23.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    @State private var confirmation = ""
    @State private var showOrderAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Text("Your total is \(order.cost.formatted(.currency(code: "USD")))")
                        .font(.title)
                    
                    Button("Place order") {
                        Task {
                            await placeOrder()
                        }
                    }
                    .padding()
                    
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Thank you!", isPresented: $showOrderAlert) {
                Button("OK") {}
            } message: {
                Text(confirmation)
            }
        }
    }
    
    func placeOrder() async {
        guard let encodedData = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encodedData)
            
            let decodedData = try JSONDecoder().decode(Order.self, from: data)
            
            confirmation = "Your order of \(decodedData.cakeAmount)x \(Order.types[decodedData.type].lowercased()) cupcakes are on their way!"
            showOrderAlert = true
        } catch {
            confirmation = "ERROR: Your order failed to be sent to server. Please try again."
            showOrderAlert = true

        }
        
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
