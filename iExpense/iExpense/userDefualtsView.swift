//
//  userDefualtsView.swift
//  iExpense
//
//  Created by Anay Sahu on 7/15/23.
//

import SwiftUI

struct Customer: Codable {
    var fName: String
    var lName: String
    var age: Int
}

struct userDefualtsView: View {
//    //@State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
//    @AppStorage("Tap") var tapCount = 0
//    var body: some View {
//        Button("Tap Count: \(tapCount)") {
//            tapCount += 1
//            //UserDefaults.standard.set(tapCount, forKey: "Tap")
//        }
//    }
    @State private var customer1 = Customer(fName: "Anay", lName: "Sahu", age: 11)
    @State private var encodedData = UserDefaults.standard.data(forKey: "Customer Data")
    @State private var cnt = 0
    var customer2: Customer {
        let decoder = JSONDecoder()
        if let customerObj = try? decoder.decode(Customer.self, from: encodedData ?? Data()) {
            print(customerObj.fName)
            print(customerObj.lName)
            return customerObj
        }
        return Customer(fName: "Archi", lName: "Sahu", age: 9)
    }
    
    
    var body: some View {
        VStack{
            Text("Name: \(customer1.fName) \(customer1.lName), age: \(customer1.age)")
            Text("\(customer2.fName) \(customer2.lName), \(customer2.age)")
            
            Button("Save User Data") {
                
                customer1 = Customer(fName: "Anay\(cnt)", lName: "Sahu\(cnt)", age: cnt)
                let encoder = JSONEncoder()
            
                if let data = try? encoder.encode(customer1) {
                    UserDefaults.standard.set(data, forKey: "Customer Data")
                }
                
                cnt += 1
                
            }
            
            
        }
    }
}

struct userDefualtsView_Previews: PreviewProvider {
    static var previews: some View {
        userDefualtsView()
    }
}
