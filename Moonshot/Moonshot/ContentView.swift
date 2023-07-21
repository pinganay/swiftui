//
//  ContentView.swift
//  Moonshot
//
//  Created by Anay Sahu on 7/17/23.
//

import SwiftUI

struct User: Codable {
    var name: String
    var address: Address
}

struct Address: Codable {
    var city: String
    var street: String
}

struct View1: View {
    var body: some View {
        Text("Another View")
    }
}

struct ContentView: View {
    var body: some View {
        
        let layout = [
            GridItem(.adaptive(minimum: 80))
        ]
        
        ScrollView(.vertical) {
            LazyVGrid(columns: layout) {
                ForEach(0..<1000) {
                    Text("Item \($0)")
                }
            }
        }
        
//        Button("Decode JSON data") {
//            let input = """
//            {
//                "name":"Anay",
//                "address": {
//                    "city":"Mountain House",
//                    "street":"945 S Central Pkwy"
//                }
//            }
//            """
//
//            let data = Data(input.utf8)
//
//            if let user = try? JSONDecoder().decode(User.self, from: data) {
//                print("\(user.address.city)")
//            }
//        }
        
//        GeometryReader { geo in
//            Image("Tree")
//                .resizable()
//                .scaledToFit()
//                .frame(width: geo.size.width * 0.8)
//                .frame(width: geo.size.width, height: geo.size.height)
//        }
        
//        ScrollView(.horizontal) {
//            LazyHStack {
//                ForEach(1..<100) {
//                    Text("\($0)")
//                }
//            }
//        }
//        NavigationView {
//            NavigationLink {
//                View1()
//            } label: {
//                Text("Hello World")
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
